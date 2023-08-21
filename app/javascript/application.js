// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";

import "./application.scss";
//
import NotificationManager from "./components/notification-manager";
import { Selector, MultiSelector } from "./components/select";

function initialize() {
  const inputs = document.querySelectorAll(".custom-select");
  for (const input of inputs) {
    input.hasAttribute("multiple") ? new MultiSelector(input) : new Selector(input);
    input.classList.remove("custom-select");
  }

  const notificationContainer = document.querySelector(".notification-container");
  const notificationManager = new NotificationManager(notificationContainer);

  document.querySelectorAll("template[data-notification]").forEach((element) => {
    notificationManager.addNotification(element);
  });
}

document.addEventListener("turbo:load", initialize);
document.addEventListener("turbo:frame-render", initialize);
