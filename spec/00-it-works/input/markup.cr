
data = {
  "msg1" => "Hello 1",
  "msg2"=> "Hello 2",
  "names"=> ["Phil", "Jon", "Dana"],
  "my_var" => "my var",
  "TITLE"=> "Hello, Test 00",
  "copyright"=> "(c)"
},

style = {
  "background"=> "1px red solid",
  "background-image" => "none",
  "div p, #id=>first-line" => { "box"=> "4px" },
  "@media (min-width=> 801px)" => {
    "body" => {
      "margin"=> "0 auto",
      "width"=> "800px"
    }
  }
}


html do
  head {
    title "TITLE"
  }
  body {
    p "msg1"
    p "msg2"
    div({"class"=>"column"}) {
      span "msg1"
      span "msg2"
      span "my_var"
    }
    each({"in" => "names", "as" => "name"}) {
      p "name"
    }
    footer "copyright"
    input({"name"=>"my-hidden", "type"=>"hidden", "value"=>"msg2"})
  }
end
