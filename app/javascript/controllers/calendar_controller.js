import { Controller } from "@hotwired/stimulus"
import { Calendar } from "@fullcalendar/core"
import dayGridPlugin from "@fullcalendar/daygrid"
import * as bootstrap from "bootstrap"

// import "@fullcalendar/core/index.css"
// import "@fullcalendar/daygrid/index.css"

export default class extends Controller {
  connect() {
    console.log("Stimulus: calendar controller connected!")

    // 既存カレンダーがあれば破棄
    if (this.calendar) {
      this.calendar.destroy()
      this.calendar = null
    }

    // DOM をクリア
    this.element.innerHTML = ""

    // FullCalendar インスタンス作成
    this.calendar = new Calendar(this.element, {
      plugins: [dayGridPlugin],
      initialView: "dayGridMonth",
      timeZone: "local",
      events: [
        {
          title: "柚子湯",
          start: "2025-12-22",  // 日付変更
          extendedProps: { modalId: "seasonalBathModal" },
        },
        {
          title: "年越しの大祓",
          start: "2025-12-31",
          extendedProps: { modalId: "eventModal" },
        }
      ],
      eventClick: (info) => {
        const modal = document.getElementById(info.event.extendedProps.modalId)
        if (modal) new bootstrap.Modal(modal).show()
      }
    })

    this.calendar.render()
  }

  // 外部からイベント一覧を取得するメソッド
  getEvents() {
    if (!this.calendar) return []
    return this.calendar.getEvents()
  }

  // 外部から日付を変更するメソッド
  goToDate(dateStr) {
    if (!this.calendar) return
    this.calendar.gotoDate(dateStr)
  }
}
