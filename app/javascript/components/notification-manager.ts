export default class NotificationManager {
  private container: HTMLElement;

  constructor(container: HTMLElement) {
    this.container = container;
  }

  public addNotification(template: HTMLTemplateElement): void {
    const notificationNode = template.content.firstElementChild;
    if (notificationNode === null) {
      throw new Error("Template is empty. It must contain a notification");
    }

    const notification = notificationNode.cloneNode(true) as HTMLElement;
    this.container.appendChild(notification);

    notification.addEventListener("transitionend", function () {
      if (!notification.classList.contains("open")) {
        notification.remove();
      }
    });

    setTimeout(() => {
      (notification as any).classList.add("open");
    });

    const timeout = template.getAttribute("timeout");
    if (timeout) {
      setTimeout(() => {
        notification.classList.remove("open");
      }, parseInt(timeout));
    }

    // Remove the notification template so we don't try and add it again.
    template.remove();
  }
}
