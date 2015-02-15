--[[
This file is just for quick testing of things and is not apart of the main test suite
]]
local upperclass = require('..upperclass')
---------------------------------------
local Node = upperclass:define("Node")

property : ownerNode {
    nil;
    get='public';
    set='public';
    type='any';
}

public.childNodes = nil

function private:__construct()
    self.childNodes = {}
    self.ownerNode = self
end

function public:appendChild(CHILD)
    CHILD.ownerNode = self
    table.insert(self.childNodes, CHILD)
end

Node = upperclass:compile(Node)
---------------------------------------
local Document = upperclass:define("Document", Node)

Document = upperclass:compile(Document)
---------------------------------------


local document = Document()
local node = Node()

print(document, document.ownerNode)
print(node, node.ownerNode)