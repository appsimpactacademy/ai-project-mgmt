import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.element.addEventListener("turbo:submit-end", (event) => {
      const { success, fetchResponse } = event.detail;

      if (success && fetchResponse) {
        // Get the step parameter from the response URL
        const params = new URLSearchParams(fetchResponse.response.url.split('?')[1]);
        const step = params.get("step"); // Get the step parameter

        if (step) { // Only update the URL if a step is present
          // Update the browser's URL without reloading the page
          const url = new URL(window.location);
          url.searchParams.set("step", step); // Use the extracted step
          history.pushState({}, '', url); // Update the browser's history
        }
      }
    });
  }
}
