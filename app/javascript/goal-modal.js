document.addEventListener("turbo:load", function () {
  window.openGoalModal = function () {
    document.getElementById("goal-modal").style.display = "flex";
  };

  window.closeGoalModal = function () {
    document.getElementById("goal-modal").style.display = "none";
  };
});