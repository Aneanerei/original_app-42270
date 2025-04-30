import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const selects = this.element.querySelectorAll("select")
    selects.forEach(select => {
      select.addEventListener("change", () => {
        this.element.submit()
      })
    })
  }
}