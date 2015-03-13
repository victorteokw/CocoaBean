CB.Window = function(){};

CB.Window.currentWindow = function() {
    this.__current || (this.__current = new CB.Window);
    return this.__current;
};