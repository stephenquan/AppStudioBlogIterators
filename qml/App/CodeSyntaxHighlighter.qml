import ArcGIS.AppFramework.Labs 1.0

SyntaxHighlighter {
    id: syntaxHighlighter

    property var keywords: app.folder.readTextFile("data/keywords.txt").split(/\s+/)
    property TextCharFormat componentFormat: TextCharFormat { foreground: "purple" }
    property TextCharFormat commentFormat: TextCharFormat { foreground: "#09885a" }
    property TextCharFormat numberFormat: TextCharFormat { foreground: "#0080aa" }
    property TextCharFormat stringFormat: TextCharFormat { foreground: "#09885a" }
    property TextCharFormat keywordFormat: TextCharFormat { foreground: "#808000" }
    property TextCharFormat propertyFormat: TextCharFormat { foreground: "#a31515" }
    property TextCharFormat identFormat: TextCharFormat { foreground: "#000000"; font.family: "Courier new"; font.pointSize: 10; font.italic: true }

    onHighlightBlock: {
        currentBlockState = 0;
        let start = 0;
        if (previousBlockState === 1) {
            let [ token, commentBody, commentEnd, body ] = text.match(/^((?:[^*]|\*(?:[^/]|$))*)(\*\/)?([\s\S]*)$/);
            let comment = commentBody + commentEnd;
            setFormat( 0, comment.length, commentFormat );
            text = body;
            start = comment.length;
            if ( !commentEnd ) {
                currentBlockState = 1;
                return;
            }
        }
        let rx = /(\/\/.*)|(\d+(?:\.\d*)?)|("(?:[^"]|\\")*")|('(?:[^']|\\')*')|([A-Z][A-Za-z0-9.]*)|([a-z][A-Za-z0-9.]*)(\s*:)?|(\/\*)((?:[^*]|\*(?:[^/]|$))*)(\*\/)?/g;
        for ( let m ; ( m = rx.exec(text) ) ; ) {
            let [ token, comment, number, str1, str2, comp, ident, attr, commentStart, commentBody, commentEnd ] = m;
            let index = start + m.index;
            let length = token.length;
            if ( comment ) {
                setFormat( index, length, commentFormat );
                continue;
            }
            if ( number ) {
                setFormat( index, length, numberFormat );
                continue;
            }
            if ( str1 || str2 ) {
                setFormat( index, length, stringFormat );
                continue;
            }
            if ( comp ) {
                setFormat( index, length, componentFormat );
                continue;
            }
            if ( ident ) {
                if ( attr ) {
                    setFormat( index, length, propertyFormat );
                    continue;
                }
                if ( keywords.indexOf( ident ) !== -1 ) {
                    setFormat( index, length, keywordFormat );
                    continue;
                }
                setFormat( index, length, identFormat );
            }
            if ( commentStart ) {
                setFormat( index, length, commentFormat );
                if ( !commentEnd ) {
                    currentBlockState = 1;
                    return;
                }
                continue;
            }
        }
    }
}
