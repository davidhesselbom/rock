import text/Buffer /* for String replace ~string */

String: class {

    buffer: Buffer

    size: SizeT { get { buffer size } ; set { } }

    init: func { buffer = Buffer new()    }

    init: func ~withBuffer(b: Buffer) { buffer = b }

    init: func ~withChar(c: Char) { buffer = Buffer new~withChar(c)) }

    init: func ~withLength (length: SizeT) { buffer = Buffer new~withLength(length) }

    init: func ~withString (s: String) { buffer = Buffer new~withBuffer( s buffer ) }

    init: func ~withCStr (s : CString) { buffer = Buffer new~withCStr(s) }

    init: func ~withCStrAndLength(s : CString, length: SizeT) { buffer = Buffer new~withCStrAndLength(s, length) }

    /** return the string's length, excluding the null byte. */
    length: func -> SizeT { buffer size }

    /** return true if *other* and *this* are equal (in terms of being null / having same size and content). */
    equals?: func (other: This) -> Bool { buffer equals? (other buffer) }

    /** return the character at position #*index* (starting at 0) */
    charAt: func (index: SizeT) -> Char { buffer charAt(index) }

    /** return a copy of *this*. */
    clone: func -> This {
        This new( buffer clone() )
    }

    substring: func ~tillEnd (start: SizeT) -> This { substring(start, buffer size) }

    substring: func (start: SizeT, end: SizeT) -> This{
        result :=clone()
        result buffer substring(start, end)
        result
    }

    /** return a This that contains *this*, repeated *count* times. */
    times: func (count: SizeT) -> This{
        result := clone()
        result buffer times(count)
        result
    }

    append: func ~str(other: This) {
        result := clone()
        result buffer append~str(other buffer)
        result
    }

    /** appends a char to either *this* or a clone*/
    append: func ~char (other: Char)  {
        result := clone()
        result buffer append~char(other)
        result
    }

    /** prepends *other* to *this*. */
    prepend: func ~str (other: This) {
        result := clone()
        result buffer prepend~str(other buffer)
        result
    }



}


operator implicit as (s: String) -> Char* {
    s buffer data
}

operator implicit as (c: Char*) -> String {
    return c ? String new (c, strlen(c)) : null
}

operator == (str1: String, str2: String) -> Bool {
    return str1 equals?(str2)
}

operator != (str1: String, str2: String) -> Bool {
    return !str1 equals?(str2)
}

operator [] (string: String, index: SizeT) -> Char {
    string charAt(index)
}

operator []= (string: String, index: SizeT, value: Char) {
    if(index < 0 || index > string length()) {
        Exception new(String, "Writing to a String out of bounds index = %d, length = %d!" format(index, string length())) throw()
    }
    (string data + index)@ = value
}

operator [] (string: String, range: Range) -> String {
    string substring(range min, range max)
}

operator * (str: String, count: Int) -> String {
    return str times(count)
}

operator + (left, right: String) -> String {
    return left append(right)
}

operator + (left: LLong, right: String) -> String {
    left toString() + right
}

operator + (left: String, right: LLong) -> String {
    left + right toString()
}

operator + (left: Int, right: String) -> String {
    left toString() + right
}

operator + (left: String, right: Int) -> String {
    left + right toString()
}

operator + (left: Bool, right: String) -> String {
    left toString() + right
}

operator + (left: String, right: Bool) -> String {
    left + right toString()
}

operator + (left: Double, right: String) -> String {
    left toString() + right
}

operator + (left: String, right: Double) -> String {
    left + right toString()
}

operator + (left: String, right: Char) -> String {
    left append(right)
}

operator + (left: Char, right: String) -> String {
    right prepend(left)
}

// lame static function to be called by int main, so i dont have to metaprogram it
import structs/ArrayList

strArrayListFromCString: func (argc: Int, argv: Char**) -> ArrayList<String> {
    result := ArrayList<String> new ()
    for (i in 0..argc) {
        s := String new ((argv[i]) as CString, (argv[i]) as CString length())
        result add( s )
    }
    result
}