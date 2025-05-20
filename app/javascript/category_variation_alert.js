document.addEventListener("turbo:load", () => {
  const modal = document.getElementById("comparison-alert-modal");
  const message = document.getElementById("comparison-alert-message");
  const closeBtn = modal?.querySelector(".comparison-alert-modal-close");
  const triggerBtn = document.getElementById("show-variation-alert");
  const labelSpan = document.getElementById("comparison-month-label");

  if (!modal || !message || !triggerBtn || !labelSpan) return;

  const format = n => `¥${n.toLocaleString()}`;
  const sign = n => {
    if (n > 0) return `+${format(n)}`;
    if (n < 0) return `−${format(Math.abs(n))}`;
    return "±0";
  };

  // 収入：増加なら青、減少なら赤
  const signedSpanIncome = n => {
    const cls = n > 0 ? "positive-diff" : (n < 0 ? "negative-diff" : "");
    return `<span class="${cls}">${sign(n)}</span>`;
  };

  // 支出：増加なら赤、減少なら青
  const signedSpanExpense = n => {
    const cls = n > 0 ? "negative-diff" : (n < 0 ? "positive-diff" : "");
    return `<span class="${cls}">${sign(n)}</span>`;
  };

  const showModal = () => {
    modal.style.display = "flex";
    setTimeout(() => modal.classList.add("show"), 10);
  };

  const hideModal = () => {
    modal.classList.remove("show");
    setTimeout(() => {
      modal.style.display = "none";
    }, 300);
  };

  closeBtn?.addEventListener("click", hideModal);
  window.addEventListener("click", (e) => {
    if (e.target === modal) hideModal();
  });

  triggerBtn.addEventListener("click", () => {
    const wrapper = document.querySelector(".calendar-wrapper");
    const month = wrapper?.dataset?.month?.trim();

    if (!month) {
      alert("表示中の月が取得できませんでした。");
      return;
    }

    fetch(`/homes/category_variation_alert?month=${month}`)
      .then(res => res.json())
      .then(data => {
        const {
          month_label,
          income_total,
          expense_total,
          income_category_change: incCat,
          expense_category_change: expCat
        } = data;

        labelSpan.textContent = `${month_label} の比較`;

        const incomeLine = `💰 <strong>収入</strong>：${month_label} ${format(income_total.current)} ／ 前月 ${format(income_total.previous)} → ${signedSpanIncome(income_total.diff)}`;
        const expenseLine = `💸 <strong>支出</strong>：${month_label} ${format(expense_total.current)} ／ 前月 ${format(expense_total.previous)} → ${signedSpanExpense(expense_total.diff)}`;
        const incomeCatLine = `📈 <strong>収入カテゴリ変動</strong>：「${incCat.category}」 → ${format(incCat.previous)} → ${format(incCat.current)}（${signedSpanIncome(incCat.diff)}）`;
        const expenseCatLine = `📉 <strong>支出カテゴリ変動</strong>：「${expCat.category}」 → ${format(expCat.previous)} → ${format(expCat.current)}（${signedSpanExpense(expCat.diff)}）`;

        message.innerHTML = `
          <p>${incomeLine}</p>
          <p>${expenseLine}</p>
          <p>${incomeCatLine}</p>
          <p>${expenseCatLine}</p>
        `;

        showModal();
      })
      .catch(err => {
        console.error("比較アラートの取得に失敗:", err);
        labelSpan.textContent = "比較エラー";
        message.innerHTML = `<p style="color:red;">比較データの取得に失敗しました。</p>`;
        showModal();
      });
  });
});
