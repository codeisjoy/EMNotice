#EMNoticeView
A customisable notice view in Swift

![EMNoticeView Screenshot](https://github.com/codeisjoy/EMNotice/blob/master/EMNoticeView.png)

You can change notice view colour theme and font and fire a sequence of notices with different duration, text and image.<br/>
Notice views will support rotation and should work for both iPhone and iPad with minimum iOS version of 8.0

##Usage
There is a default centre that is responsible to fire notices. The only thing should be done is defining the custom notice and add that into queue and then ask the default centre to fire the queue.

	let notice: EMNoticeView = EMNoticeView(duration: 5)
	notice.backgroundColor = UIColor.BlueColor()
	notice.textLabel.text = “The first notice message.”
	notice.imageView.image = UIImage(named: “notice”)

This defines a notice that will be shown for 5 seconds. The background colour is blue and the text message and image are what have been set.

	EMNoticeCenter.defaultCenter().addNotice(notice)

This line adds the notice into queue. You can add as many notices as you want to fire.

	EMNoticeCenter.defaultCenter().fire()

Then <code>fire()</code> to have the first notice appeared.

You can add more notice into the queue until <code>EMNoticeCenter</code> is alive and is showing notices. After dismissing the last one if you add any notice into the queue you need to <code>fire()</code> again unless adding notice with “self-firing” method.

	EMNoticeCenter.defaultCenter().fireNotice(
		duration: 5,
		type: EMNoticeType.Error,
		message: “The notice message…”,
		image: nil)

This way you are defining the notice that will be fired immediately. This is an easy was yo get the notice shown but the options are limited.<br/>
This method needs a <code>type</code> for notice which is a value of EMNoticeType enum. This actually defines the background colour of the notice. 

##Customising the view appearance
The background colour, text colour, font and alignment could be customised per notice view when it is being initialised. Another way is using <code>UIAppearance</code> protocol to do this.

####• backgroundColor: UIColor
To change the notice view background colour.
To simplify, there is an enum of <code>EMNoticeType</code> with predefined values of types and their associated colours. To have <code>UIColor</code> value of each type the method <code>.toColor()</code> should be called.<br/>
Default value is the red colour of <code>EMNoticeType.Error.toColor()</code>

	EMNoticeView.appearance().backgroundColor = EMNoticeType.Warning.toColor()

####• textColor: UIColor
To change the notice text colour. Default value is white.

	EMNoticeView.appearance().textColor = UIColor.BlackColor()

####• textFont: UIFont
To change the font of notice text. Default value is <code>UIFont.systemFontOfSize(14)</code>

	EMNoticeView.appearance().textFont = UIFont.boldSystemFontOfSize(16)

####• textAlignment: NSTextAlignment
To change the alignment of notice text. Default value is <code>NSTextAlignment.Left</code>

	EMNoticeView.appearance().textAlignment = NSTextAlignment.Center

## Install
Simply add this as a submodule then import `EMNoticeView` folder into your Xcode project.

	git submodule add https://github.com/codeisjoy/EMNoticeView.git <your lib directory>

## Note
This lib has been written in Swift 1.1 which is the latest released version and will be upgraded to 1.2 as soon as it is released officially.
