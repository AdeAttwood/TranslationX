import Fuse from "fuse.js";

function createSelectElement() {
  const parent = document.createElement("div");
  parent.classList.add("selector");

  const input = document.createElement("input");
  input.setAttribute("type", "text");
  parent.appendChild(input);

  const datalist = document.createElement("datalist");
  parent.appendChild(datalist);

  return { parent, input, datalist };
}

export class Selector {
  element: HTMLSelectElement;
  #input: HTMLInputElement;
  #datalist: HTMLDataListElement;

  #selected: HTMLOptionElement;

  #fuse = new Fuse<{ option: HTMLOptionElement; content: string }>([], { keys: ["content"] });

  constructor(element: HTMLSelectElement) {
    const { parent, input, datalist } = createSelectElement();

    this.element = element;
    this.#datalist = datalist;
    this.#input = input;

    this.#input.setAttribute("placeholder", this.getPlaceHolderText() || "");

    // Hide the original select
    element.setAttribute("hidden", "true");

    // Copy all the options into the datalist from the select
    Array.from(this.element.options).forEach((item) => {
      const option = item.cloneNode(true) as HTMLOptionElement;
      option.addEventListener("click", this.onSelect);
      option.addEventListener("mouseover", this.onHover);

      datalist.appendChild(option);
      this.#fuse.add({ option, content: option.innerText });
    });

    // console.log(this.#fuse.getIndex());

    // Add the "select" into the dom
    const parentElement = this.element.parentElement;
    if (!parentElement) {
      throw new Error("Select element must have a parent to add the selector into");
    }

    parentElement.insertBefore(parent, this.element);

    // Add the event listeners
    this.#input.addEventListener("focus", this.onFocus);
    this.#input.addEventListener("blur", this.onBlur);
    this.#input.addEventListener("input", this.onInput);
  }

  getPlaceHolderText() {
    return this.element.selectedOptions.item(0)?.innerText;
  }

  setValue(event: any) {
    this.element.value = event.target.value;
  }

  onFocus = () => {
    this.#datalist.setAttribute("open", "true");
  };

  onInput = (event: any) => {
    const docs = this.#fuse.search(event.target?.value);
    docs.reverse().forEach((doc) => {
      this.#datalist.prepend(doc.item.option);
      doc.item.option.hidden = false;
    });

    for (let i = docs.length; i < this.#datalist.options.length; i++) {
      this.#datalist.options[i].hidden = true;
    }
  };

  onBlur = () => {
    // Wait a bit before closing the datalist to make sure the click event is
    // triggered
    setTimeout(() => {
      this.#datalist.removeAttribute("open");
      this.#input.value = "";
    }, 100);
  };

  onSelect = (event) => {
    this.setValue(event);

    this.#selected?.removeAttribute("aria-selected");
    this.#input.value = "";
    this.#input.setAttribute("placeholder", this.getPlaceHolderText() || "");

    this.#datalist.removeAttribute("open");
  };

  onHover = (event: any) => {
    this.#selected?.removeAttribute("aria-selected");
    this.#selected = event.target;
    this.#selected.setAttribute("aria-selected", "true");
  };
}

export class MultiSelector extends Selector {
  constructor(element: HTMLSelectElement) {
    super(element);

    console.log(this.element.selectedOptions);
  }

  setValue(event: any) {
    const option = this.element.querySelector(`option[value="${event.target.value}"]`);
    if (!option) {
      return;
    }

    if (option.hasAttribute("selected")) {
      option.removeAttribute("selected");
      event.target.removeAttribute("selected");
    } else {
      option.setAttribute("selected", "true");
      event.target.setAttribute("selected", true);
    }
  }

  getPlaceHolderText() {
    return Array.from(this.element.selectedOptions)
      .map((option) => option.innerText)
      .join(", ");
  }
}
