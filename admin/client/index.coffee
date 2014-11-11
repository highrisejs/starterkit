React = require('react')

ProductEdit = require('admin/components/product_edit')

props = JSON.parse($('script[data-props="productEdit"]').html())
React.renderComponent(
  ProductEdit props
  document.getElementById 'product-edit'
)
