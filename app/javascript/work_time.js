document.addEventListener("turbo:load", () => {
  const openBtn = document.getElementById("show-worktime-form");
  const modal = document.getElementById("worktime-modal");
  const closeBtn = document.getElementById("close-worktime-modal");

  if (openBtn && modal && closeBtn) {
    openBtn.addEventListener("click", () => modal.style.display = "flex");
    closeBtn.addEventListener("click", () => modal.style.display = "none");
  }
});