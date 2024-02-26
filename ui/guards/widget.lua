local oop = require "lib.oop"

return function(proto)
  if not proto.render then
    error "ui::widget a widget should always have a render method!"
  end

  return oop(proto)
end
