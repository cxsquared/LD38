package yarn;
import flixel.FlxG;
import openfl.Assets;

using StringTools;

typedef Node = { title:String, text:String }
typedef Line = { text:String, index:Int, tabs:Int }
typedef Option = { text:String, nodeTitle:String }

class Yarn {

    private var fileName:String = "";
    private var nodes = new List<Node>();
    private var currentNode:Node;
    private var currentLineIndex:Int;
    private var options = new List<Option>();
    private var runningNode:String;
    private var lastNodeTitle:String;
    private var lastLineIndex:Int;
    private var currentCharacter:String;
    private var currentLine:String;
    private var variables:Map<String, Int> = new Map<String, Int>();

    public function new(filePath:String) {
        var json:Array<Dynamic> = haxe.Json.parse(Assets.getText(filePath));

        parseYarnJson(json);
    }

    private function parseYarnJson(parsedJson:Array<Dynamic>): Void {
        for(node in parsedJson)
        {
            if (Reflect.hasField(node, "title") && Reflect.hasField(node, "body")) {
                var title = cast(Reflect.field(node, "title"), String).trim();
                var body = cast(Reflect.field(node, "body"), String).trim().replace('\r', '\n');
                nodes.add({ title:title, text:body});
            }
        }
    }

    private function GetNode(title:String):Node {
        for(node in nodes)
        {
            if (node.title == title) {
                return node;
            }
        }

        return null;
    }

    private function GetCurrentLine():String {
        return currentNode.text.split('\n')[currentLineIndex];
    }

    public function Run(startNode:String = "Start", startLineIndex:Int = 0) {
        currentNode = GetNode(startNode);
        currentLineIndex = startLineIndex;
        RunLine(currentNode, currentLineIndex);
    }

    public function NextLine()
    {
        currentLineIndex++;
        RunLine(currentNode, currentLineIndex);
    }

    private function RunLine(node:Node, lineIndex:Int) {
        currentLineIndex = lineIndex;
        currentNode = node;
        var lines = currentNode.text.split('\n');
        while(lines[currentLineIndex] == "") {
           currentLineIndex++;
        }
        if (currentLineIndex >= lines.length)
        {
            return;
        }

        var line = lines[currentLineIndex];
        if (line.substring(0,2) == "<<")
        {
            ParseCommand(line);
            return;
        }
        if (line.substring(0,2) == "[[")
        {
            ParseOption(line);
            return;
        }

        ParseText(line);
    }

    private function ParseCommand(line:String) {
        var command = line.split(' ')[0].substr(2).trim();
        if (command == "set") {
            var varRegex = ~/\$(\w+)\s+to\s+(\w+)>>/;
            varRegex.match(line);
            var variableName = varRegex.matched(1);
            variables.set(varRegex.matched(1), Std.parseInt(varRegex.matched(2)));
            NextLine();
            return;
        } else if (command == "if") {
            var varRegex = ~/\$(\w+)\s+(==|>|<|>=|<=)\s+(\w+)>>/;
            varRegex.match(line);
            if (!variables.exists(varRegex.matched(1))) {
                return;
            }
            var varValue = variables.get(varRegex.matched(1));
            var comparValue = Std.parseInt(varRegex.matched(3));
            var comparer = varRegex.matched(2);
            if ((comparer == "==" && varValue == comparValue) ||
                (comparer == ">" && varValue > comparValue) ||
                (comparer == "<" && varValue < comparValue) ||
                (comparer == "<=" && varValue <= comparValue) ||
                (comparer == ">=" && varValue >= comparValue)) {
                    NextLine();
            } else
            {
                FlxG.log.warn("Invalid comparor on node " + currentNode.title + " at line " + currentLineIndex);
                FindEndIf();
            }
            return;
        } else if (command == "endif")
        {
            NextLine();
            return;
        }

        FlxG.log.error("Invalid command on node " + currentNode.title + " at line " + currentLineIndex);
    }

    private function FindEndIf()
    {
        currentLineIndex++;
        while (GetCurrentLine().trim() != "<<endif>>") {
            currentLineIndex++;
        }
        NextLine();
    }

    private function ParseOption(line:String) {
        var text = line.split('|')[0].substr(2);
        var title = line.split('|')[1].substr(0, line.split('|')[1].length - 2);
        options.add({text:text, nodeTitle:title});
        NextLine();
    }

    private function ParseText(line:String) {
        currentCharacter = line.split(':')[0].trim();
        currentLine = line.substring(currentCharacter.length+1).trim();
    }

    public function GetCharacter():String {
        return currentCharacter;
    }

    public function GetCurrentText():String {
        if (options.length != 0) {
            setOptions();
        }
        return currentLine;
    }

    public function SelectOption(optionIndex:Int) {
        currentLineIndex = 0;
        currentNode = GetNode(getOptionNode(optionIndex));
        options.clear();
        RunLine(currentNode, currentLineIndex);
    }

    public function HasOptions():Bool {
        return options.length > 0;
    }

    private function setOptions():String {
        currentLine = "";
        for(option in options) {
            currentLine += option.text + "\n";
        }
        return currentLine;
    }

    private function getOptionNode(optionIndex:Int):String {
        var currentIndex = 0;
        for(option in options) {
            if (currentIndex == optionIndex) {
                return option.nodeTitle;
            }
        }

        return "";
    }

}
