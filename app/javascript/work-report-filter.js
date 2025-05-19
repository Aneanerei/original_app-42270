function bindCategoryFilterButtons() {
  const buttons = document.querySelectorAll(".category-badge");
  const reports = document.querySelectorAll(".report-entry");

  buttons.forEach((btn) => {
    btn.addEventListener("click", () => {
      const category = btn.dataset.category;

      // ボタンのactive切り替え
      buttons.forEach(b => b.classList.remove("active"));
      btn.classList.add("active");

      reports.forEach((entry) => {
        if (category === "all" || entry.dataset.category === category) {
          entry.style.display = "block";
        } else {
          entry.style.display = "none";
        }
      });
    });
  });
}

document.addEventListener("turbo:load", bindCategoryFilterButtons);