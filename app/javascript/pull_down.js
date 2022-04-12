function  pullDown(){
  const pullDownButton = document.getElementById("pull-down-button");
  const randomMenu = document.getElementById("random-menu");
  
  pullDownButton.addEventListener("click", () => {
    randomMenu.classList.toggle("hidden");
    pullDownButton.classList.toggle("active");
  });
};

window.addEventListener('load', pullDown);