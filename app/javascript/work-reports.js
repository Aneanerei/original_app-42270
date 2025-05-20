function bindReadMoreButtons() {
  document.querySelectorAll(".read-more-btn").forEach((btn) => {
    if (btn.dataset.bound === "true") return;
    btn.dataset.bound = "true";

    btn.addEventListener("click", () => {
      const container = document.getElementById(btn.dataset.target);
      if (!container) return;

      const shortText = container.querySelector(".report-text.short");
      const fullText = container.querySelector(".report-text.full");

      if (!shortText || !fullText) return;

      const isExpanded = fullText.style.display === "block";

      if (isExpanded) {
        fullText.style.display = "none";
        shortText.style.display = "block";
        btn.textContent = "続きを読む";
      } else {
        fullText.style.display = "block";
        shortText.style.display = "none";
        btn.textContent = "閉じる";
      }
    });
  });
}

document.addEventListener("turbo:load", bindReadMoreButtons);
document.addEventListener("turbo:render", bindReadMoreButtons);
