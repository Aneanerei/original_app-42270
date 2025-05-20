document.addEventListener("turbo:load", () => {
  const modal = document.getElementById("day-summary-modal");
  if (!modal) return;

  const closeBtn = modal.querySelector(".day-modal-close");
  const title = modal.querySelector("#day-modal-title");
  const incomeList = modal.querySelector("#day-income-list");
  const expenseList = modal.querySelector("#day-expense-list");
  const imageList = modal.querySelector("#day-image-list");
  const workList = modal.querySelector("#day-worktime-list");
  const workMemo = modal.querySelector("#day-work-memo");

  document.querySelectorAll("[data-date]").forEach(day => {
    day.addEventListener("click", async () => {
      const date = day.dataset.date;

      try {
        const response = await fetch(`/homes/day_summary?date=${date}`);
        if (!response.ok) throw new Error("データ取得失敗");

        const data = await response.json();
        title.textContent = `${data.date} の記録`;

        // 収入（カテゴリ・金額・メモ）
        incomeList.innerHTML = data.incomes?.length
          ? data.incomes.map(i => `
              <li>
                <div><strong>${i.category}</strong>: ¥${i.amount.toLocaleString()}</div>
                <div class="day-memo-line">📝 ${i.memo}</div>
              </li>
            `).join("")
          : "<li>記録なし</li>";

        // 支出（カテゴリ・金額・メモ）
        expenseList.innerHTML = data.expenses?.length
          ? data.expenses.map(e => `
              <li>
                <div><strong>${e.category}</strong>: ¥${e.amount.toLocaleString()}</div>
                <div class="day-memo-line">📝 ${e.memo}</div>
              </li>
            `).join("")
          : "<li>記録なし</li>";

        // 画像（タグ・メモ付き）
        imageList.innerHTML = data.images?.length
          ? data.images.map(img => `
              <div class="day-image-item">
                <img src="${img.url}" alt="" class="day-thumb">
                <p>🏷️ ${img.tags.join(" / ")}</p>
                <p>📝 ${img.memo || "（メモなし）"}</p>
              </div>
            `).join("")
          : "<p>画像の記録なし</p>";

        // 労働時間（カテゴリ・時間）
        workList.innerHTML = data.work_times?.length
          ? data.work_times.map(wt => `<li>${wt.category}: ${(wt.duration / 60).toFixed(1)} 時間</li>`).join("")
          : "<li>記録なし</li>";

        // 労働メモ（複数を結合）
        workMemo.textContent = data.work_times?.map(w => w.memo).filter(Boolean).join("\n") || "";

        modal.style.display = "flex";
      } catch (error) {
        alert("その日の記録を読み込めませんでした。");
        console.error(error);
      }
    });
  });

  if (closeBtn) {
    closeBtn.addEventListener("click", () => {
      modal.style.display = "none";
    });
  }

  window.addEventListener("click", (e) => {
    if (e.target === modal) {
      modal.style.display = "none";
    }
  });
});
