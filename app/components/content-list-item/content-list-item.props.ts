import { ViewStyle } from "react-native"
import { SwipeRow } from "react-native-swipe-list-view"

import { Content } from "../../models/content"

export interface ContentListItemStyleProps {
  /**
   * The background color of the list item. Default is white.
   */
  backgroundColor?: string

  /**
   * The color of the underlay that will show through when the touch is active on the list item.
   */
  underlayColor?: string

  /**
   * The primary color of the skeleton for loading.
   */
  skeletonPrimaryColor?: string

  /**
   * The secondary color of the skeleton for loading.
   */
  skeletonSecondaryColor?: string
}

export interface ContentListItemProps extends ContentListItemStyleProps {
  content: Content

  /**
   * Set to false to hide the bookmark icon. Default is true.
   */
  isShowBookmarkIcon?: boolean

  /**
   * An optional style override useful for padding & margin.
   */
  style?: ViewStyle

  /**
   * A callback when the item is pressed.
   */
  onPress?: (url: string) => void

  /**
   * A callback when the bookmark button is pressed.
   */
  onToggleBookmark?: (url: string) => void

  /**
   * A callback when the follow button is pressed.
   */
  onToggleFollow?: (content: Content) => void

  /**
   * A callback when the undo button is pressed.
   */
  onPressUndoButton?: (content: Content) => void

  /**
   * A callback when the list item is swiped to open.
   */
  onSwipeOpen?: (key: string, ref: React.RefObject<SwipeRow<{}>>) => void

  /**
   * A callback when the list item is swiped to close.
   */
  onSwipeClose?: (key: string) => void
}
