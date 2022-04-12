function  textChange(){
  const randomMenuDate = document.getElementById("random-menu-date");
  const randomMenuSubmit = document.getElementById("random-menu-submit");

  randomMenuDate.addEventListener("change", () => {
    if (randomMenuDate.value === ""){
      randomMenuSubmit.value = "一週間おまかせ"
    }else{
      randomMenuSubmit.value = "おまかせ"
    };
  });
};

window.addEventListener('load', textChange);