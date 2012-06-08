html ->
  head ->
    meta charset:'utf-8'
    script src:'jquery-1.7.2.min.js'
    script src:'jquery.getimagedata.min.js'
    style type:'text/css', 'body {font-family: monospace; text-align:center;}'

  body ->
    div id:'loading', style:'display:none', 'Please Wait...'

    form id:'f', style:'display:none', ->
      input type:'text', placeholder:'Image URL', name:'i'
      button 'Do it.'
    
    pre id:'t', style:'display:none', ->
      """
      """

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

      sampleText = 'Select All. '
      imgUrl = getParameterByName 'i'
      if imgUrl is ''
        $('#f').attr('style','display:block')
      else
        $('#loading').show()
        width = 150
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

          error: (e) ->
            console.log e
            alert 'Aw shucks, we couldn\'t load that.'
