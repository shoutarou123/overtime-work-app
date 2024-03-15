import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  // フォームが送信されたときに呼ばれるメソッド
  submit(event) {
    // フラッシュメッセージ領域をクリアする
    const flashContainer = document.getElementById('flash');
    if (flashContainer) {
      flashContainer.innerHTML = '';
      flashContainer.className = '';
    }

    // フォーム送信後の処理（例: モーダルを閉じる）
    this.close();
  }


  // モーダルを閉じるメソッド
  close() {
    this.element.remove(); // モーダルの要素を削除
  }
}