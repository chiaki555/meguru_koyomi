import { Controller } from "@hotwired/stimulus"
import { Calendar } from "@fullcalendar/core" // カレンダーを使う準備
import dayGridPlugin from "@fullcalendar/daygrid"
import * as bootstrap from "bootstrap"

export default class extends Controller {
  connect() {  // ページにHTML側のdata-controller="calendar"がついた要素が表示されたタイミングで呼ばれる
    const calendar = new Calendar(this.element, {  // this.element：HTML側のdata-controller="calendar"がついた要素
      plugins: [dayGridPlugin],
      initialView: "dayGridMonth",
      events: [
        {
          title: "柚子湯",
          start: "2025-12-22",
          extendedProps: { modalId: "seasonalBathModal" },
        }
      ],
      eventClick: function(info) {
        console.log("クリックイベント:", info.event.title)
        console.log("modalId:", info.event.extendedProps.modalId)
        const modal = document.getElementById(info.event.extendedProps.modalId)
        console.log("modal要素:", modal)
        if(modal) {
          const bootstrapModal = new bootstrap.Modal(modal)
          bootstrapModal.show()
        }
      }
    })
    calendar.render()  // 画面にカレンダーを出す
  }
}
