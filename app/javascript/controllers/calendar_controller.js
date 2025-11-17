import { Controller } from "@hotwired/stimulus"
import { Calendar } from "@fullcalendar/core" // カレンダーを使う準備
import dayGridPlugin from "@fullcalendar/daygrid"

export default class extends Controller {
  connect() {  // ページにHTML側のdata-controller="calendar"がついた要素が表示されたタイミングで呼ばれる
    const calendar = new Calendar(this.element, {  // this.element：HTML側のdata-controller="calendar"がついた要素
      plugins: [dayGridPlugin],
      initialView: "dayGridMonth"
    })
    calendar.render()  // 画面にカレンダーを出す
  }
}
