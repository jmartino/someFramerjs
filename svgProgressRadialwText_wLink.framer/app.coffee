# svg progress radial with updating text
# learned a lot from 
# http://codepen.io/JMChristensen/pen/Ablch
# http://jakearchibald.com/2013/animated-line-drawing-svg/
# http://commons.oreilly.com/wiki/index.php/SVG_Essentials/Animating_and_Scripting_SVG
# dynamic text chat https://www.facebook.com/groups/framerjs/permalink/652275838232824/
# http://share.framerjs.com/353l402houaw/
# jacquelyn 15mar2015

##svg

#setting up
fillColor = "transparent"
strokeColor = "#8CD211"
strokeWidth = 10
circleRadius = 200
circleRotation = -90 #control where on the circle to start the progress from

# compute these relationships
circleStrokewidth =  circleRadius*0.25
circleWidth = (circleRadius+circleStrokewidth) *2.0
circleHeight = circleWidth
circleX = circleWidth/2
circleY = circleX
circum = 2* Math.PI*circleRadius

# define svgs
circleStatic = "<svg width='" + circleWidth +  "' height='" +circleHeight+ "'><circle cx='"+circleX+ "' cy='"+circleY+ "' r='" +circleRadius+ "' stroke='black' stroke-width='1' stroke-opacity='1.0'  fill='none' /></svg>"

circleProgress = "<svg width='" + circleWidth +  "' height='" +circleHeight+ "'>
<text id='textPrct' text-anchor='middle' alignment-baseline='middle' x='"+circleX+ "' y='"+circleY+ "' >0</text>
<circle cx='"+circleX+ "' cy='"+circleY+ "' r='" +circleRadius+ "' stroke='black' stroke-width='1' fill='yellow'  transform='rotate(" +circleRotation+ "," +circleX+ "," +circleY+ ")' </circle> 
</svg>"

##layers
bg = new BackgroundLayer

#the progressive svg circle
svgLayer = new Layer 
	backgroundColor:"transparent"
	width: circleWidth
	height:circleHeight
svgLayer.center()
svgLayer.html = circleProgress

svgTextElement = svgLayer.querySelector("#textPrct")
svgTextElement.style.font = circleStrokewidth + "px/1.0em Helvetica"


svgCircleElement = svgLayer.querySelector("circle")
svgCircleElement.style.webkitTransition = 'all 1s linear'
svgCircleElement.style.fill = fillColor
svgCircleElement.style.stroke = strokeColor
svgCircleElement.style.strokeWidth = circleStrokewidth


# start with no progress
svgCircleElement.style.strokeDasharray = circum+ " " +circum 
svgCircleElement.style.strokeDashoffset = circum

#draw static svg circle behind the progressive circle
doSVGstatic = (op) ->		
	svgLayerTemplate = svgLayer.copy()
	svgLayerTemplate.index = svgLayer.index - 1
	svgLayerTemplate.html = circleStatic
	svgCircleTemplate = svgLayerTemplate.querySelector("circle")
	svgCircleTemplate.style.fill = fillColor
	svgCircleTemplate.style.stroke = "gray"
	svgCircleTemplate.style.strokeOpacity = op #0.25
	svgCircleTemplate.style.strokeWidth = circleStrokewidth
	
doSVGstatic(0.25) 

percentText = new Layer
	backgroundColor : ""
	width:circleWidth/3
	
percentText.center()
percentText.y = svgLayer.midY - circleRadius/8#25
Utils.labelLayer(percentText,"")
percentText.style.font = circleStrokewidth + "px/1.0em Helvetica"
percentText.style.color = "gray"

textInputLayer = new Layer 
	width: svgLayer.width
	backgroundColor:"transparent"
textInputLayer.center()
textInputLayer.y = svgLayer.maxY

# This creates a text input and adds some styling 
inputElement = document.createElement("input")
inputElement.style.width  = "#{textInputLayer.width}px"
inputElement.style.height = "#{textInputLayer.height}px"
inputElement.style.font = circleStrokewidth + "px/1.0em Helvetica"
inputElement.style.webkitUserSelect = "text"
inputElement.style.paddingLeft = "7px"
inputElement.style.backgroundColor= "transparent"
inputElement.style.textAlign = "left"
inputElement.style.outline = "none"

# Set the value, focus and listen for changes
inputElement.placeholder = "Type in a percentage"
inputElement.value = ""
inputElement.focus()

# count up to the percentage
counter = (i,j,t) ->
	svgTextElement.textContent = j
	if j>=i
		clearInterval(t)

#draw the progress stroke on the circle
doPercentage = (percentage) ->
	i = percentage #end the number display here
	j = 0	#start the number display here
	
	progress = (1-(percentage/100)) #get ready to stroke some progress

	if progress == 1 	
		svgCircleElement.style.strokeDashoffset = circum
	else
		upperBound = circum*progress
		svgCircleElement.style.strokeDashoffset = upperBound
		
	#draw the count upward to usere's input percentage
	t = setInterval((->counter i, j++,t), 1000/(i*10))
  
# get some user input for the percentage
inputElement.onkeyup = (e) ->
	
	if e.keyCode is 13 #on enter
	
		# Set the textvalue
		textVal = inputElement.value
		
		if isNaN(parseInt(textVal)) or parseInt(textVal)>100 or parseInt(textVal)<=0
			inputElement.placeholder = "Whoops, try again?"
						
		else 
			doPercentage(parseInt(textVal))	
			inputElement.placeholder = "Type in a percentage"
						
		# Clear the value
		inputElement.value = ""	

# Place text input layer on screen
textInputLayer._element.appendChild(inputElement)








