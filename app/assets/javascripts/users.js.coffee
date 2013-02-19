jQuery ->
  $('#users').dataTable
    sPaginationType: "full_numbers"
    bJQueryUI: true
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#users').data('source')
    sDom: "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>"
    sPaginationType: "bootstrap"
