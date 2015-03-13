Function.prototype.property = function(prop, desc) {
    if (!desc) {
        desc = {};
    }
    if (!desc.set) {
        desc.set = function(newValue) {
            return this["_" + prop] = newValue;
        };
    }
    if (!desc.get) {
        desc.get = function() {
            return this["_" + prop];
        };
    }
    return Object.defineProperty(this.prototype, prop, desc);
};