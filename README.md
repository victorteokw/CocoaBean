# CocoaBean

![Logo](https://raw.githubusercontent.com/cheunghy/CocoaBean/master/logo.jpg)

[![Build status](https://travis-ci.org/cheunghy/CocoaBean.svg?branch=master)](https://travis-ci.org/cheunghy/CocoaBean)

CocoaBean is a multi-platform javaScript framework. It uses real OOP and MVC. It tries to mimic local app development just like Android and iOS. Currently, the api structure is nearly the same as Apple's Cocoa and Cocoa Touch framework. In the future, it may change or may not change. It depends. However and always, one native style code base can generate multiple apps with javaScript.

## How to try it out?
Clone the framework to your local directory
``` bash
git clone https://github.com/cheunghy/CocoaBean.git
```

And then cd to the framework
``` bash
cd path/to/cocoabean
```

Run this command, you may need sudo if gems are installed to system directory
``` bash
rake install
```
If bash tells you `-bash: rake: command not found`, you may need to install ruby.

See instructions [here](https://www.ruby-lang.org/en/documentation/installation/).

Now CocoaBean framework should be installed as a gem.

To create an app, using `cocoabean new APP_PATH`.

To preview it in the browser, using `cocoabean preview web`.

To unit test it, using `cocoabean test web`.

To distribute the app, using `cocoabean dist web`.

To change default app setting, modify `Beanfile`.

You may customize cocoabean behavior through `~/.cocoabeanrc`.

For the documentation, just refer to Apple's Cocoa Touch and Cocoa documentation for now.
Notice there is some mappings, `CB.View` is equivalent to `UIView` or `NSView`,
`CB.ViewController` is equivalent to `UIViewController` or `NSViewController`,
`CB.Rect`, `CB.Size`, `CB.Point` are equivalents of `CGRect`, `CGSize` and `CGPoint`.

## Implementation status

| Platform | Status |
|:--------:|:--------:|
| Web browser | done a lot |
| iOS | will start |
| Android | will start |
| OS X | will start |
|Windows | in the discussion |

* Do you want to take part in it?
Email me at yeannylam@gmail.com

## Development

This framework is under development.

Any contribution is welcome.

Usage of this framework and contribution is in the wiki.

If you find any bugs or if you have feature request, welcome to fire an issue [here](https://github.com/cheunghy/CocoaBean/issues).

## Need your help!
There are a lot of works should be done, just take it freely!

**Command line interface:**

* Refactor generation code to rake task based.

* Add unit tests to cli code.

* Require activesupport and use `it "bla bla"` style unit test titles.

**Web platform implementation:**

* Core extension to Array, String and Object.

* Should we add an enumerator type just like ruby did?

* Code documentation.

You may join the discussion at anytime!

## A sample CocoaBean application
[chess game](https://github.com/cheunghy/chess)
![Screen shot](https://raw.githubusercontent.com/cheunghy/CocoaBean/master/sshot.png)
