<template>
  <aside class="neko-menu" :class="{ floating, minimized: floating && minimized }" :style="panelStyle" ref="panel">
    <!-- Floating-mode drag handle with minimize button -->
    <div v-if="floating" class="float-handle" @mousedown.prevent="onHandleMousedown" @click.stop="onHandleClick">
      <i class="fas fa-grip-horizontal drag-icon" />
      <i class="fas fa-comment-alt chat-icon" />
      <span class="float-title">Chat</span>
      <span v-if="minimized && unreadCount > 0" class="unread-badge">{{ unreadCount }}</span>
      <button v-if="!minimized" class="btn-minimize" @click.stop="minimize">
        <i class="fas fa-window-minimize" />
      </button>
    </div>

    <div v-if="!floating" class="resize-handle" @mousedown.prevent="startResize" />
    <div class="tabs-container" @mousedown="onTabsMousedown">
      <ul>
        <li :class="{ active: tab === 'chat' }" @click.stop.prevent="change('chat')">
          <i class="fas fa-comment-alt" />
          <span>{{ $t('side.chat') }}</span>
        </li>
        <li v-if="filetransferAllowed" :class="{ active: tab === 'files' }" @click.stop.prevent="change('files')">
          <i class="fas fa-file" />
          <span>{{ $t('side.files') }}</span>
        </li>
        <li :class="{ active: tab === 'settings' }" @click.stop.prevent="change('settings')">
          <i class="fas fa-sliders-h" />
          <span>{{ $t('side.settings') }}</span>
        </li>
        <li class="float-toggle" @click.stop.prevent="toggleFloat" :title="floating ? 'Dock chat' : 'Float chat'">
          <i :class="floating ? 'fas fa-table-columns' : 'fas fa-up-right-from-square'" />
        </li>
        <li v-if="!floating" class="overlay-toggle" @click.stop.prevent="activateOverlay" title="Overlay mode">
          <i class="fas fa-comment-dots" />
        </li>
      </ul>
    </div>
    <div class="page-container">
      <neko-chat v-if="tab === 'chat'" />
      <neko-files v-if="tab === 'files'" />
      <neko-settings v-if="tab === 'settings'" />
    </div>
  </aside>
</template>

<style lang="scss">
  .neko-menu {
    position: relative;
    width: var(--chat-width, #{$side-width});
    background-color: $background-primary;
    flex-shrink: 0;
    max-height: 100%;
    max-width: 100%;
    display: flex;
    flex-direction: column;

    .resize-handle {
      position: absolute;
      left: 0;
      top: 0;
      bottom: 0;
      width: 5px;
      cursor: col-resize;
      z-index: 10;
      transition: background 0.15s;

      &:hover {
        background: rgba($style-primary, 0.5);
      }
    }

    .float-handle {
      background: $background-tertiary;
      height: 30px;
      display: flex;
      align-items: center;
      padding: 0 8px 0 10px;
      cursor: grab;
      flex-shrink: 0;
      user-select: none;
      gap: 6px;

      &:active {
        cursor: grabbing;
      }

      .drag-icon {
        color: $text-muted;
        font-size: 12px;
        opacity: 0.55;
      }

      .chat-icon {
        display: none;
        color: $style-primary;
        font-size: 14px;
      }

      .float-title {
        flex: 1;
        font-size: 11px;
        font-weight: 700;
        color: $text-muted;
        text-transform: uppercase;
        letter-spacing: 0.8px;
      }

      .unread-badge {
        background: $style-primary;
        color: white;
        border-radius: 10px;
        padding: 1px 7px;
        font-size: 11px;
        font-weight: 700;
        min-width: 18px;
        text-align: center;
      }

      .btn-minimize {
        background: none;
        border: none;
        color: $text-muted;
        cursor: pointer;
        padding: 0;
        width: 22px;
        height: 22px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 3px;
        flex-shrink: 0;

        &:hover {
          color: $text-normal;
          background: $background-modifier-hover;
        }

        i {
          font-size: 10px;
        }
      }
    }

    .tabs-container {
      background: $background-tertiary;
      height: $menu-height;
      max-height: 100%;
      max-width: 100%;
      display: flex;
      flex-shrink: 0;

      ul {
        display: flex;
        align-items: flex-end;
        width: 100%;
        padding: 0 0 0 0;
        margin: 0;
        height: 100%;

        li {
          background: $background-secondary;
          border-radius: 3px 3px 0 0;
          border-bottom: none;
          display: inline-flex;
          align-items: center;
          padding: 5px 10px;
          margin-right: 4px;
          font-weight: 600;
          cursor: pointer;
          height: 26px;

          i {
            margin-right: 4px;
            font-size: 10px;
          }

          &.active {
            background: $background-primary;
          }

          &.float-toggle,
          &.overlay-toggle {
            background: transparent;
            opacity: 0.5;
            border-radius: 3px;

            i {
              margin-right: 0;
            }

            &:hover {
              opacity: 1;
              background: $background-modifier-hover;
            }
          }

          &.float-toggle {
            margin-left: auto;
            margin-right: 2px;
          }

          &.overlay-toggle {
            margin-right: 6px;
          }
        }
      }
    }

    .page-container {
      max-height: 100%;
      flex-grow: 1;
      display: flex;
      overflow: auto;
      padding-top: 5px;
    }

    &.floating {
      position: fixed;
      right: 20px;
      bottom: 20px;
      height: 500px;
      z-index: 900;
      background-color: rgba($background-primary, 0.85);
      backdrop-filter: blur(8px);
      -webkit-backdrop-filter: blur(8px);
      border-radius: 10px;
      box-shadow: 0 8px 32px rgba(0, 0, 0, 0.6);
      border: 1px solid rgba(255, 255, 255, 0.07);
      resize: both;
      overflow: hidden;
      min-width: 250px;
      min-height: 300px;
      max-width: 90vw;
      max-height: 90vh;

      .float-handle {
        border-radius: 0;
      }

      .tabs-container {
        cursor: default;
        user-select: none;
      }

      .page-container {
        overflow: auto;
      }
    }

    &.floating.minimized {
      height: auto;
      min-height: 0;
      min-width: 0;
      width: auto;
      resize: none;

      .tabs-container,
      .page-container {
        display: none;
      }

      .float-handle {
        cursor: pointer;
        min-width: 110px;
        padding: 0 14px;
        justify-content: center;
        border-radius: 10px;

        .drag-icon {
          display: none;
        }

        .chat-icon {
          display: block;
        }

        .float-title {
          flex: 0 auto;
        }

        &:hover {
          background: $background-floating;
        }
      }
    }
  }
</style>

<script lang="ts">
  import { Vue, Component, Watch, Ref } from 'vue-property-decorator'

  import Settings from '~/components/settings.vue'
  import Chat from '~/components/chat.vue'
  import Files from '~/components/files.vue'

  @Component({
    name: 'neko',
    components: {
      'neko-settings': Settings,
      'neko-chat': Chat,
      'neko-files': Files,
    },
  })
  export default class extends Vue {
    @Ref('panel') readonly panel!: HTMLElement

    unreadCount = 0
    private _lastHistoryLen = 0

    get filetransferAllowed() {
      return (
        this.$accessor.remote.fileTransfer && (this.$accessor.user.admin || !this.$accessor.isLocked('file_transfer'))
      )
    }

    get tab() {
      return this.$accessor.client.tab
    }

    get floating() {
      return this.$accessor.client.floating
    }

    get minimized() {
      return this.$accessor.client.chatMinimized
    }

    get history() {
      return this.$accessor.chat.history
    }

    get chatWidth() {
      return this.$accessor.client.chatWidth
    }

    get chatX() {
      return this.$accessor.client.chatX
    }

    get chatY() {
      return this.$accessor.client.chatY
    }

    get panelStyle(): Record<string, string> {
      if (!this.floating) return {}
      if (this.chatX >= 0 && this.chatY >= 0) {
        return {
          left: this.chatX + 'px',
          top: this.chatY + 'px',
          right: 'auto',
          bottom: 'auto',
        }
      }
      return {}
    }

    @Watch('floating')
    onFloatingChange(floating: boolean) {
      if (!floating && this.panel) {
        this.panel.style.width = ''
        this.panel.style.height = ''
        this.$accessor.client.setChatMinimized(false)
      }
    }

    @Watch('minimized')
    onMinimizedChange() {
      this.unreadCount = 0
      this._lastHistoryLen = this.history.length
    }

    @Watch('history')
    onHistoryChange() {
      const newLen = this.history.length
      if (this.minimized && this.floating) {
        const added = newLen - this._lastHistoryLen
        if (added > 0) this.unreadCount += added
      }
      this._lastHistoryLen = newLen
    }

    @Watch('tab', { immediate: true })
    @Watch('filetransferAllowed', { immediate: true })
    onTabChange() {
      if (this.tab === 'files' && !this.filetransferAllowed) {
        this.change('chat')
      }
    }

    @Watch('filetransferAllowed')
    onFileTransferAllowedChange() {
      if (this.filetransferAllowed) {
        this.$accessor.files.refresh()
      }
    }

    change(tab: string) {
      this.$accessor.client.setTab(tab)
    }

    toggleFloat() {
      this.$accessor.client.toggleFloating()
    }

    activateOverlay() {
      this.$accessor.client.setOverlay(true)
    }

    minimize() {
      this._lastHistoryLen = this.history.length
      this.unreadCount = 0
      this.$accessor.client.setChatMinimized(true)
    }

    unminimize() {
      this.$accessor.client.setChatMinimized(false)
    }

    onHandleMousedown(e: MouseEvent) {
      if (!this.floating || this.minimized) return
      this.startDrag(e)
    }

    onHandleClick() {
      if (this.minimized) this.unminimize()
    }

    onTabsMousedown(e: MouseEvent) {
      if (!this.floating) return
      const target = e.target as HTMLElement
      if (target.closest('li')) return
      e.preventDefault()
      this.startDrag(e)
    }

    startResize(e: MouseEvent) {
      const startX = e.clientX
      const startWidth = this.chatWidth

      const onMove = (ev: MouseEvent) => {
        const delta = startX - ev.clientX
        const newWidth = Math.max(250, Math.min(800, startWidth + delta))
        this.$accessor.client.setChatWidth(newWidth)
      }

      const onUp = () => {
        document.removeEventListener('mousemove', onMove, true)
        document.removeEventListener('mouseup', onUp, true)
        document.body.style.cursor = ''
        ;(document.body.style as any).userSelect = ''
      }

      document.body.style.cursor = 'col-resize'
      ;(document.body.style as any).userSelect = 'none'
      document.addEventListener('mousemove', onMove, true)
      document.addEventListener('mouseup', onUp, true)
    }

    startDrag(e: MouseEvent) {
      const rect = this.panel.getBoundingClientRect()
      const offsetX = e.clientX - rect.left
      const offsetY = e.clientY - rect.top

      const onMove = (ev: MouseEvent) => {
        const x = Math.max(0, Math.min(window.innerWidth - rect.width, ev.clientX - offsetX))
        const y = Math.max(0, Math.min(window.innerHeight - 40, ev.clientY - offsetY))
        this.$accessor.client.setChatPosition({ x, y })
      }

      const onUp = () => {
        document.removeEventListener('mousemove', onMove, true)
        document.removeEventListener('mouseup', onUp, true)
        ;(document.body.style as any).userSelect = ''
      }

      ;(document.body.style as any).userSelect = 'none'
      document.addEventListener('mousemove', onMove, true)
      document.addEventListener('mouseup', onUp, true)
    }
  }
</script>
