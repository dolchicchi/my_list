function addForm (){
  const addBtn = document.getElementById('add-btn');
  addBtn.addEventListener("click",() => {
    const html = `
      <div class="ingredient">
        <div class="ingredient-name">
          <label for="recipe_ingredient_name">食材名</label>
          <input name="[recipe_ingredient][name][]" type="text"  />
        </div>

        <div class="ingredient-amount">
          <label for="recipe_ingredient_amount">分量</label>
          <input name="[recipe_ingredient][amount][]" type="text"  />
        </div>

        <div class="ingredient-unit">
          <label for="recipe_ingredient_unit_id">単位</label>
          <select name="[recipe_ingredient][unit_id][]" ><option value="1">---</option>
          <option value="2">グラム</option>
          <option value="3">コ</option>
          <option value="4">本</option>
          <option value="5">束</option>
          <option value="6">cc</option>
          <option value="7">カップ</option></select>
        </div>
      </div>`;
    const actions = document.getElementById('actions');
    actions.insertAdjacentHTML("beforebegin", html);
  });
};

function deleteForm (){
  const deleteBtn = document.getElementById('delete-btn');
  deleteBtn.addEventListener("click",() => {
    const ingredient = document.querySelector('.ingredient');
    ingredient.remove();
  })
};



window.addEventListener('load', addForm);
window.addEventListener('load', deleteForm);