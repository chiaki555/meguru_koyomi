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
      events: this.fetchEvents.bind(this),
      datesSet: () => this.updateSidebar(),
      eventClick: (info) => this.openModalFromEvent(info.event),  // ← ここで呼ぶだけ

      eventContent: (arg) => {
        const iconUrl = arg.event.extendedProps.event_icon_url
        const title = arg.event.title

        if (!iconUrl) {
          return { html: `<span>${title}</span>` }
        }

        return {
          html: `
            <span class="d-inline-flex align-items-center gap-1">
              <img src="${iconUrl}" width="16" height="16" />
              <span>${title}</span>
            </span>
          `
        }
      }
    })

    this.calendar.render()
  }

  // サイドバー統合
  updateSidebar() {
    this.updateMonthlyBaths()
    this.updateTodayOrNextEvent()
  }

  // サイドバー：今月の季節湯
  updateMonthlyBaths() {
    const list = document.querySelector(".js-monthly-baths")
    if (!list) return

    list.innerHTML = ""

    // カレンダーが表示している月を取得
    const viewDate = this.calendar.getDate()
    const year = viewDate.getFullYear()
    const month = viewDate.getMonth()

    const baths = this.calendar.getEvents().filter(event => {
      if (event.extendedProps.type !== "bath") return false

      const date = event.start
      return date.getFullYear() === year && date.getMonth() === month
    })

    baths.forEach(event => {
      const li = document.createElement("li")

      const a = document.createElement("a")
      a.href = "#"

      // アイコンがあれば表示
      if (event.extendedProps.event_icon_url) {
        const img = document.createElement("img")
        img.src = event.extendedProps.event_icon_url
        img.classList.add("me-1")
        img.style.width = "16px"
        img.style.height = "16px"
        img.style.verticalAlign = "middle"

        a.appendChild(img)
      }

      // 季節湯名
      const span = document.createElement("span")
      span.textContent = event.title

      a.appendChild(span)
      a.classList.add("small")

      // サイドバーのリンクからもモーダルを開く
      a.addEventListener("click", e => {
      e.preventDefault()
      this.openModalFromEvent(event)
      })

      li.appendChild(a)
      list.appendChild(li)
    })
  }

  // サイドバー：今日 or 次の行事
  updateTodayOrNextEvent() {
    const label = document.querySelector(".js-event-label")
    const list = document.querySelector(".js-event-title")
    if (!label || !list) return

    list.innerHTML = ""

    const today = new Date()
    today.setHours(0, 0, 0, 0)

    const events = this.calendar
      .getEvents()
      .filter(e => e.extendedProps.type === "event")
      .sort((a, b) => a.start - b.start)

    // 今日の行事（複数）
    const todayEvents = events.filter(e => {
      const d = new Date(e.start)
      d.setHours(0, 0, 0, 0)
      return d.getTime() === today.getTime()
    })

    let targetEvents = []

    if (todayEvents.length > 0) {
      label.textContent = "今日の行事"
      targetEvents = todayEvents
    } else {
      // 次に来る日付を探す
      const nextEvent = events.find(e => e.start > today)
      if (!nextEvent) return

      const nextDate = new Date(nextEvent.start)
      nextDate.setHours(0, 0, 0, 0)

      label.textContent = "次の行事"

      // 同じ日の行事を全部取得
      targetEvents = events.filter(e => {
        const d = new Date(e.start)
        d.setHours(0, 0, 0, 0)
        return d.getTime() === nextDate.getTime()
      })
    }

    // 複数描画
    targetEvents.forEach(event => {
      const li = document.createElement("li")
      const a = document.createElement("a")
      a.href = "#"

      // アイコンがあれば表示
      if (event.extendedProps.event_icon_url) {
        const img = document.createElement("img")
        img.src = event.extendedProps.event_icon_url
        img.classList.add("me-1")
        img.style.width = "16px"
        img.style.height = "16px"
        img.style.verticalAlign = "middle"

        a.appendChild(img)
      }

      // 行事名
      const span = document.createElement("span")
      span.textContent = event.title

      a.appendChild(span)

      a.addEventListener("click", e => {
        e.preventDefault()
        this.openModalFromEvent(event)
      })

      li.appendChild(a)
      list.appendChild(li)
    })
  }

  async fetchEvents(info, successCallback, failureCallback) {
    try {
      const res = await fetch("/homes.json")
      const data = await res.json()
      successCallback(data)
    } catch (e) {
      failureCallback(e)
    }
  }

  // モーダルを開く処理メソッド
  openModalFromEvent(event) {
    const modal = document.getElementById(event.extendedProps.modalId)
    if (!modal) return

    modal.querySelector(".js-modal-title").textContent = event.title
    modal.querySelector(".js-modal-description").textContent =
      event.extendedProps.description

    // 行事サムネイル
    const eventThumb = modal.querySelector(".js-event-thumbnail")
    if (eventThumb) {
      eventThumb.src = event.extendedProps.event_thumbnail_url
      eventThumb.classList.remove("d-none")
    }

    // 行事食
    const foodsEl = modal.querySelector(".js-modal-foods")
    foodsEl.innerHTML = ""
    ;(event.extendedProps.event_foods || []).forEach(food => {
      const li = document.createElement("li")

      const img = document.createElement("img")
      img.src = food.thumbnail_url
      img.classList.add("img-fluid", "me-2")

      const span = document.createElement("span")
      span.textContent = food.name

      li.appendChild(img)
      li.appendChild(span)
      foodsEl.appendChild(li)
    })

    // おすすめスポット
    const spotsEl = modal.querySelector(".js-modal-spots")
    spotsEl.innerHTML = ""

    ;(event.extendedProps.recommended_spots || []).forEach(spot => {
      const li = document.createElement("li")

      if (spot.image_url) {
        const img = document.createElement("img")
        img.src = spot.image_url
        img.classList.add("img-fluid", "me-2")
        li.appendChild(img)
      }

      const span = document.createElement("span")
      span.textContent = spot.name
      li.appendChild(span)

      spotsEl.appendChild(li)
    })

    bootstrap.Modal.getOrCreateInstance(modal).show()
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
