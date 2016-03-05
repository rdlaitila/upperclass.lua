local upperclass = require('..upperclass')

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::

--
-- Define our class
--
local class = upperclass:define('lure.dom.Document')

--
-- Here you can specify class implimentations that will be 
-- inherited by this class. You can specify a single class
-- implimentation for single inheritance or multiple classes
-- for multiple inheritance. You can specify the class name
-- as a string or the actual complied class object
--
class.inherits {
    'lure.dom.Base';
    'lure.dom.Node';
}

--
-- Specify interfaces of other classes that this class impliments
--
class.impliments {
    'lure.dom.Base';
    'lure.dom.Node';
}

--
--
--
class.public.documentElement {
    default=nil;
    nullable=true;
    setter='private';
    type='lure.dom.Node';
}