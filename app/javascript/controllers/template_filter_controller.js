import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="template-filter"
export default class extends Controller {
  connect() {
    this.filterTemplate(); // Initial call, if needed
  }

  filterTemplate(event) {
    const filterValue = event ? event.target.value : 'Basic'; // Get the selected filter value
    const templateCard = document.querySelector("#template-card");

  	fetch(`/select_template?template_name=${filterValue}`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        "Accept": "text/vnd.turbo-stream.html"
      }
    })
    .then(response => response.text())
    .then(turboStream => {
    	templateCard.insertAdjacentHTML('beforeend', turboStream);
    })
    .catch(error => {
      console.error('Error fetching messages:', error);
    });
  }
}
