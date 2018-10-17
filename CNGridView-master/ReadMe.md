[![Flattr this git repo](http://api.flattr.com/button/flattr-badge-large.png)](https://flattr.com/submit/auto?user_id=phranck&url=https://github.com/phranck/CNGridView&title=CNGridView&tags=github&category=software)
![Travis Status](https://travis-ci.org/phranck/CNGridView.png?branch=master)



## Overview
`CNGridView` is a (wanna be) replacement for `NSCollectionView`. It has full delegate and dataSource support with method calls just like known from [NSTableView](https://developer.apple.com/library/mac/#documentation/Cocoa/Reference/ApplicationKit/Classes/NSTableView_Class/Reference/Reference.html) and [UITableView](http://developer.apple.com/library/ios/#documentation/uikit/reference/UITableView_Class/Reference/Reference.html).

The main inspiration to develop this control came fom [@JustSid](https://github.com/JustSid) who wrote the [JUCollectionView](https://github.com/JustSid/JUCollectionView). But `CNGridView` was written from ground up, it uses ARC and has a bunch of properties to customize its layout and behavior.
`CNGridView` was only testet on 10.7 Lion & 10.8 Mountain Lion.

Here is a shot of the included example application:

![CNGridView Example Application](https://dl.dropbox.com/u/34133216/WebImages/Github/CNGridView-Example.png)


## Usage
To use `CNGridView` the easy work is done in a few steps:

- open InterfaceBuilder and select your NIB file that should contain the grid view
- drag a `NSScrollView` to your target view, and set the class of `NSScrollView`'s content view to `CNGridView`
- connect the delegate & dataSource
- implement all required delegate/dataSource methods and fill it with appropriate content.

Now you have a fully functionable grid view. Please take a look at the example.


## Contribution

The code is provided as-is, and it is far off being complete or free of bugs. If you like this component feel free to support it. Make changes related to your needs, extend it or just use it in your own project. Pull-Requests and Feedbacks are very welcome. Just contact me at [phranck@cocoanaut.com](mailto:phranck@cocoanaut.com?Subject=[CNGridView] Your component on Github) or send me a ping on Twitter [@TheCocoaNaut](http://twitter.com/TheCocoaNaut). 


## Documentation
The complete documentation you will find on [CocoaDocs](http://cocoadocs.org/docsets/CNGridView/).


## License
This software is published under the [MIT License](http://cocoanaut.mit-license.org).



## Software that uses CNGridView
If you like this component and if you're using it in your own software so please let me know. I'll give you a mention and set a link to your website (or the Mac App Store, if it exists).

`CNGridView` is used by this software:
* **[Unbound](http://unboundformac.com)** - Unbound is a faster, simpler photo manager.
* **[TunesBar+](https://itunes.apple.com/us/app/tunesbar+/id702817673?mt=12)** - TunesBar+ simply sits in your menubar and tells you what track is currently playing in iTunes.