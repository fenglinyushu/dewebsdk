/**
 * 设置el-table单元格样式
 * @param {String} dom el-table id
 * @param {Number} row 单元格所在行
 * @param {Number} column 单元格所在列
 * @param {Object} style 样式集合
 * @param {Boolean} isFixed 是否有固定列
 * @example 
 * jsSetStyle('table1', 1, 2, {
      backgroundColor: 'red',
      fontFamily: '宋体',
      fontSize: '20px',
      fontWeight: 600,
      fontStyle: 'italic',
      color: '#fff',
    })
 */
function dwSGSetStyle(dom, row, column, style, isFixed = false) {
  if (row === 0) {
    if (isFixed) {
      const fixedParent = document.getElementById(dom)
      setTimeout(() => {
        const fixedTarget = 
          fixedParent
          .getElementsByClassName('el-table__fixed-right')[0]
          .getElementsByClassName('el-table__fixed-header-wrapper')[0]
          .getElementsByClassName('el-table__header')[0]
          .getElementsByTagName('thead')[0]
          .getElementsByTagName('tr')[0]
          .childNodes[column]
        for (const key in style) {
          fixedTarget.style[key] = style[key]
        }
      }, 0)
    } else {
      const parent = 
        document.getElementById(dom)
        .getElementsByClassName('el-table__header-wrapper')[0]
        .getElementsByTagName('table')[0]
        .getElementsByTagName('thead')[0]
        .getElementsByTagName('tr')[0]
        .childNodes
      setTimeout(() => {
        const target = parent[column]
        for (const key in style) {
          target.style[key] = style[key]
        }
      }, 0)
    }
  } else {
    if (isFixed) {
      const parent = document.getElementById(dom)
      setTimeout(() => {
        const target = 
          parent
          .getElementsByClassName('el-table__fixed-right')[0]
          .getElementsByClassName('el-table__fixed-body-wrapper')[0]
          .getElementsByClassName('el-table__body')[0]
          .getElementsByTagName('tbody')[0]
          .childNodes[row - 1]
          .childNodes[column]
        for (const key in style) {
          target.style[key] = style[key]
        }
      })
    } else {
      const parent = 
        document.getElementById(dom)
        .getElementsByClassName('el-table__body-wrapper')[0]
        .getElementsByClassName('el-table__body')[0]
        .getElementsByTagName('tbody')[0]
        .getElementsByTagName('tr')[row - 1]
      setTimeout(() => {
        const target = parent.childNodes[column]
        for (const key in style) {
          target.style[key] = style[key]
        }
      }, 0)
    }
  }
}

/**
 * 设置el-table单行样式
 * @param {String} dom el-table id
 * @param {Number} row 单元格所在行
 * @param {Object} style 样式集合
 * @param {Boolean} isFixed 是否有固定列
 * @example 
 * jsSetRow('table1', 1, { backgroundColor: 'green', color: '#fff' })
 */
 function dwSGSetRow(dom, row, style, isFixed = false) {
  
  if (row === 0) {
    const target = 
      document.getElementById(dom)
      .getElementsByClassName('el-table__header-wrapper')[0]
      .getElementsByTagName('table')[0]
      .getElementsByTagName('thead')[0]
      .getElementsByTagName('tr')[0]
    setTimeout(() => {
      target.childNodes.forEach(child => {
        for (const key in style) {
          child.style[key] = style[key]
        }
      })
    }, 0)
    if (isFixed) {
      const fixedParent = document.getElementById(dom)
      setTimeout(() => {
        const fixedTarget = 
          fixedParent
          .getElementsByClassName('el-table__fixed-right')[0]
          .getElementsByClassName('el-table__fixed-header-wrapper')[0]
          .getElementsByClassName('el-table__header')[0]
          .getElementsByTagName('thead')[0]
          .getElementsByTagName('tr')[0]
        fixedTarget.childNodes.forEach(child => {
          for (const key in style) {
            child.style[key] = style[key]
          }
        })
      }, 0)
    }
  } else {
    const parent = 
      document.getElementById(dom)
      .getElementsByClassName('el-table__body-wrapper')[0]
      .getElementsByClassName('el-table__body')[0]
      .getElementsByTagName('tbody')[0]
      .getElementsByTagName('tr')[row - 1]
    setTimeout(() => {
      const target = parent.childNodes
      target.forEach(child => {
        for (const key in style) {
          child.style[key] = style[key]
        }
      })
    }, 0)
    if (isFixed) {
      const fixedParent = document.getElementById(dom)
      setTimeout(() => {
        const fixedTarget = 
          fixedParent
          .getElementsByClassName('el-table__fixed-right')[0]
          .getElementsByClassName('el-table__fixed-body-wrapper')[0]
          .getElementsByClassName('el-table__body')[0]
          .getElementsByTagName('tbody')[0]
          .getElementsByTagName('tr')[row - 1]
        fixedTarget.childNodes.forEach(child => {
          for (const key in style) {
            child.style[key] = style[key]
          }
        })
      }, 0)
    }
  }
}

/**
 * 设置el-table单列样式
 * @param {String} dom el-table id
 * @param {Number} column 单元格所在列
 * @param {Object} style 样式集合
 * @param {Boolean} isFixed 是否有固定列
 * @example 
 * jsSetColumn('table1', 1, { backgroundColor: 'green', color: '#fff' })
 */
function dwSGSetCol(dom, column, style, isFixed = false) {
  if (isFixed) {
    const fixedParent = document.getElementById(dom)
    setTimeout(() => {
      const fixedTarget = 
        fixedParent
        .getElementsByClassName('el-table__fixed-right')[0]
        .getElementsByClassName('el-table__fixed-body-wrapper')[0]
        .getElementsByClassName('el-table__body')[0]
        .getElementsByTagName('tbody')[0]
      fixedTarget.childNodes.forEach(v => {
        v.childNodes.forEach((vv, vvIndex) => {
          if (vvIndex + 1 === column + 1) {
            for (const key in style) {
              vv.style[key] = style[key]
            }
          }
        })
      })
    }, 0)
  } else {
    const target = 
      document.getElementById(dom)
      .getElementsByClassName('el-table__body-wrapper')[0]
      .getElementsByClassName('el-table__body')[0]
      .getElementsByTagName('tbody')[0]
    target.childNodes.forEach(v => {
      setTimeout(() => {
        v.childNodes.forEach((vv, vvIndex) => {
          if (vvIndex + 1 === column + 1) {
            for (const key in style) {
              vv.style[key] = style[key]
            }
          }
        }, 0)
      })
    })
  }
}