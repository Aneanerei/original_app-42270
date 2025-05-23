function bindCategoryFilterButtons() {
  const buttons = document.querySelectorAll(".category-badge");
  const dateBlocks = document.querySelectorAll(".daily-date-block");

  buttons.forEach((btn) => {
    btn.addEventListener("click", () => {
      const selected = btn.dataset.category;

      // アクティブ状態を更新
      buttons.forEach((b) => b.classList.remove("active"));
      btn.classList.add("active");

      // 各日付ブロックのエントリ表示を切り替え
      dateBlocks.forEach((block) => {
        const entries = block.querySelectorAll(".report-entry");
        let visibleCount = 0;

        entries.forEach((entry) => {
          const entryCategory = entry.dataset.category || "";

          if (
            selected === "all" ||
            entryCategory.includes(selected)
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

// Turbo対応で毎回再バインド
document.addEventListener("turbo:load", () => {
  bindCategoryFilterButtons();
  bindReadMoreButtons();
});

document.addEventListener("turbo:render", () => {
  bindCategoryFilterButtons();
  bindReadMoreButtons();
});
