function calculation (){
  const count = document.getElementsByTagName("tbody")[0].childElementCount - 1;

  for ( let i = 0; i < count; i++ ){
    const useAmount = document.getElementsByTagName("td")[i * 4 + 1].firstElementChild.textContent;
    const inputTag = document.getElementsByTagName("td")[i * 4 + 2].firstElementChild;
    const innerArea = document.getElementsByTagName("td")[i * 4 + 3].firstElementChild;
    const unitDate = document.getElementsByTagName("td")[i * 4 + 3]
    innerArea.textContent = useAmount

    inputTag.addEventListener('change', () => {
      const stock = inputTag.value
      const shoppingAmount = useAmount - stock
      if (0 < shoppingAmount){
        innerArea.textContent = shoppingAmount
      } else {
        innerArea.textContent = "0";
      }
    })
  }
};

window.addEventListener('load', calculation);