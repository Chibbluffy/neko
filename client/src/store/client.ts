import { getterTree, mutationTree, actionTree } from 'typed-vuex'
import { get, set } from '~/utils/localstorage'

export const namespaced = true

export const state = () => ({
  side: get<boolean>('side', false),
  tab: get<string>('tab', 'chat'),
  about: false,
  about_page: '',
  floating: get<boolean>('chatFloating', false),
  overlay: get<boolean>('chatOverlay', false),
  chatWidth: get<number>('chatWidth', 400),
  chatX: get<number>('chatX', -1),
  chatY: get<number>('chatY', -1),
  chatMinimized: false,
})

export const getters = getterTree(state, {})

export const mutations = mutationTree(state, {
  setTab(state, tab: string) {
    state.tab = tab
    set('tab', tab)
  },
  setAbout(state, page: string) {
    state.about_page = page
  },
  toggleAbout(state) {
    state.about = !state.about
  },
  toggleSide(state) {
    state.side = !state.side
    set('side', state.side)
  },
  setSide(state, side: boolean) {
    state.side = side
    set('side', side)
  },
  toggleFloating(state) {
    const next = !state.floating
    state.floating = next
    set('chatFloating', next)
    if (next) {
      state.overlay = false
      set('chatOverlay', false)
    }
  },
  setOverlay(state, overlay: boolean) {
    state.overlay = overlay
    set('chatOverlay', overlay)
    if (overlay) {
      state.floating = false
      set('chatFloating', false)
      // always open the panel when entering overlay mode
      if (!state.side) {
        state.side = true
        set('side', true)
      }
    }
  },
  setChatWidth(state, width: number) {
    state.chatWidth = width
    set('chatWidth', width)
  },
  setChatPosition(state, { x, y }: { x: number; y: number }) {
    state.chatX = x
    state.chatY = y
    set('chatX', x)
    set('chatY', y)
  },
  setChatMinimized(state, value: boolean) {
    state.chatMinimized = value
  },
})

export const actions = actionTree({ state, getters, mutations }, {})
