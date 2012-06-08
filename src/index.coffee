html ->
  head ->
    meta charset:'utf-8'
    script src:'jquery-1.7.2.min.js'
    script src:'jquery.getimagedata.min.js'
    style type:'text/css', 'body {font-family: monospace; text-align:center;}'

  body ->
    div id:'msg', style:'display:none;color:red;font-weight:bold'
    div id:'loading', style:'display:none', 'Please Wait...'

    form id:'f', style:'display:none', ->
      input type:'text', placeholder:'Image URL', name:'i'
      button 'Do it.'
    
    pre id:'t', style:'display:none', ->
      """
      """

    div id:'link', style:'display:none', ->
      a href:'.', 'lol wat'

    coffeescript ->
      ###           ###
      #               #
      #  ,d88b.d88b,  #
      #  888hello888  #
      #  `Y8888888Y'  #
      #    `Y888Y'    #
      #      `Y'      #
      #               #
      ###           ###
      getParameterByName = (name) ->
        name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
        regexS = "[\\?&]" + name + "=([^&#]*)"
        regex = new RegExp(regexS)
        results = regex.exec(window.location.search)
        unless results?
          ""
        else
          decodeURIComponent results[1].replace(/\+/g, " ")

      getPixel = (imageData, x,y, w,h) ->
        index = (x + y * imageData.width) * 4
        r=imageData.data[index]
        g=imageData.data[index + 1]
        b=imageData.data[index + 2]
        a=imageData.data[index + 3]
        return "rgb(#{r},#{g},#{b})"

      sampleText = """There's one company now you can sign up and you can get a movie delivered to your house daily by delivery service. Okay. And currently it comes to your house, it gets put in the mail box when you get home and you change your order but you pay for that, right. But this service isn't going to go through the internet and what you do is you just go to a place on the internet and you order your movie and guess what you can order ten of them delivered to you and the delivery charge is free. Ten of them streaming across that internet and what happens to your own personal internet? I just the other day got, an internet was sent by my staff at 10 o'clock in the morning on Friday and I just got it yesterday. Why? Because it got tangled up with all these things going on the internet commercially. So you want to talk about the consumer? Let's talk about you and me. We use this internet to communicate and we aren't using it for commercial purposes. We aren't earning anything by going on that internet. Now I'm not saying you have to or you want to discriminate against those people [...] The regulatory approach is wrong. Your approach is regulatory in the sense that it says "No one can charge anyone for massively invading this world of the internet". No, I'm not finished. I want people to understand my position, I'm not going to take a lot of time. [?] They want to deliver vast amounts of information over the internet. And again, the internet is not something you just dump something on. It's not a truck. It's a series of tubes. And if you don't understand those tubes can be filled and if they are filled, when you put your message in, it gets in line and its going to be delayed by anyone that puts into that tube enormous amounts of material, enormous amounts of material. Now we have a separate Department of Defense internet now, did you know that? Do you know why? Because they have to have theirs delivered immediately. They can't afford getting delayed by other people. [...] Now I think these people are arguing whether they should be able to dump all that stuff on the internet ought to consider if they should develop a system themselves. Maybe there is a place for a commercial net but it's not using what consumers use every day. It's not using the messaging service that is essential to small businesses, to our operation of families. The whole concept is that we should not go into this until someone shows that there is something that has been done that really is a violation of net neutrality that hits you and me."""
      imgUrl = getParameterByName 'i'
      if imgUrl is ''
        $('#f').attr('style','display:block')
      else
        $('#loading').show()
        width = 120
        # Get image:
        $.getImageData
          url:imgUrl
          success: (img) ->
            canvas = document.createElement 'canvas'
            w = Math.round(width)
            h = Math.round((width/img.width) * img.height)/2
            canvas.setAttribute 'width', w
            canvas.setAttribute 'height', h
            ctx = canvas.getContext '2d'
            ctx.drawImage img, 0,0, w,h
            map = ctx.getImageData 0,0, w,h
            
            text = ''
            css = ''
            x=0
            y=0
            i=0
            while y < h
              while x < w
                css += ".p#{x}_#{y}::selection{background:#{getPixel(map,x,y,w,h)};}"
                text += "<span class='p#{x}_#{y}'>#{sampleText[i%sampleText.length]}</span>"
                ++x
                ++i
              text += '\n'
              x = 0
              ++y

            $('html > head').append($('<style>'+css+'</style>'))

            t=$ '#t'
            t.attr('style','display:block')
            t.html(text)
            $('#loading').hide()
            $('#link').show()

          error: (e) ->
            $('#link').hide()
            $('#loading').hide()
            $('#t').hide()
            $('#f').show()
            $('#msg').html('Hmm. Something went wrong. Try again/try something else.').show()
