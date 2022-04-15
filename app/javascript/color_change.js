function  colorChange(){
  const categoryName = document.querySelectorAll('.category-name')
  

  categoryName.forEach(function(element){

    if (element.textContent === '主菜'){
      element.classList.add('red');
    }else if (element.textContent === '副菜'){
      element.classList.add('blue');
    }else if (element.textContent === 'スープ'){
      element.classList.add('yellow');
    };
    
  });
};

window.addEventListener('load', colorChange);