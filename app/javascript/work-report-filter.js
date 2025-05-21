function bindCategoryFilterButtons() {
  const buttons = document.querySelectorAll(".category-badge");
  const reports = document.querySelectorAll(".report-entry");
  const dateBlocks = document.querySelectorAll(".daily-date-block");

  buttons.forEach((btn) => {
    btn.addEventListener("click", () => {
      const selected = btn.dataset.category;

      // ボタンのactive切り替え
      buttons.forEach((b) => b.classList.remove("active"));
      btn.classList.add("active");

      dateBlocks.forEach((block) => {
        const entries = block.querySelectorAll(".report-entry");
        let visibleCount = 0;

        entries.forEach((entry) => {
          const entryCategory = entry.dataset.category || "";
          if (
            selected === "all" ||
            entryCategory.includes(selected) ||
            (selected === "労働" && entryCategory.includes("労働"))
          ) {
            entry.style.display = "block";
            visibleCount++;
          } else {
            entry.style.display = "none";
          }
        });

        block.style.display = visibleCount > 0 ? "block" : "none";
      });
    });
  });
}

document.addEventListener("turbo:load", bindCategoryFilterButtons);
