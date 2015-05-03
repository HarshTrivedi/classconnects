ActiveAdmin.register InappropriateType do
  menu label: "Report Types" , :priority => 10


  filter :report_type , :label => "type"

end