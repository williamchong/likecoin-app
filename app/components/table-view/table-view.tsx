import * as React from "react"
import { View } from "react-native"
import styled from "styled-components/native"
import { TableViewCellProps } from "./table-view-cell"

const Separator = styled.View`
  height: 1px;
  background-color: ${({ theme }) => theme.color.separator};
`

interface TableViewProps {
  children: React.ReactElement | React.ReactElement[]
}

export function TableView(props: TableViewProps) {
  const children: React.ReactElement[] = []
  const lastIndex = React.Children.count(props.children) - 1
  React.Children.forEach(props.children, (child, index) => {
    if (index > 0) {
      children.push(<Separator key={`separator-${index}`} />)
    }
    children.push(
      React.cloneElement<TableViewCellProps>(
        child,
        {
          ...child.props,
          key: `${index}`,
          isFirstCell: index === 0,
          isLastCell: index === lastIndex,
        }
      )
    )
  })
  return (
    <View>
      {children}
    </View>
  )
}
