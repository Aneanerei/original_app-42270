document.addEventListener("turbo:load", () => {
  const buttons = document.querySelectorAll(".analysis-button");
  const contents = document.querySelectorAll(".analysis-content");
  const desc = document.getElementById("analysis-desc-text");

  const descriptions = {
    "analysis-income": "月別の収入合計と内訳をグラフと表で確認できます。",
    "analysis-expense": "月ごとの支出金額を集計・可視化します。",
    "analysis-savings": "収入から支出を差し引いた貯金額の推移を表示します。",
    "analysis-worktime": "毎月の労働時間の推移を確認できます。",
    "analysis-total-summary": "総労働時間・日数など全体の労働実績を表示します。",
    "analysis-category-stats": "カテゴリごとの月別労働時間を詳しく分析します。",
    "analysis-ratio": "年間労働時間の割合を円グラフで確認できます。"
  };

  buttons.forEach(button => {
    button.addEventListener("click", () => {
      const targetId = button.dataset.target;

      // 表示切り替え
      contents.forEach(content => {
        content.style.display = (content.id === targetId) ? "block" : "none";
      });

      // activeクラス切り替え
      buttons.forEach(btn => btn.classList.remove("active"));
      button.classList.add("active");

      // 説明テキスト切り替え
      if (desc && descriptions[targetId]) {
        desc.textContent = descriptions[targetId];
      } else if (desc) {
        desc.textContent = "選択した分析の概要がここに表示されます。";
      }
    });
  });
});
