const comments: string = `
<!-- - - - - - - - - - - Report bugs or help us develop new ones! - - - - - - - - - - -->
<!-- - - - - - - - - - - - https://github.com/JustinLex/markedb - - - - - - - - - - - -->
<!-- 00110001 00110001 00110001 00110001 00110000 00110000 00110000 00110000 00100000 -->
<!-- 00110001 00110000 00110000 00110001 00110001 00110001 00110001 00110001 00100000 -->
<!-- 00110001 00110000 00110000 00110000 00110000 00110001 00110000 00110001 00100000 -->
<!-- 00110001 00110000 00110001 00110001 00110000 00110000 00110000 00110001 00100000 -->
<!-- 00110001 00110001 00110001 00110000 00110001 00110001 00110001 00110001 00100000 -->
<!-- 00110001 00110000 00110001 00110001 00110001 00110000 00110000 00110000 00100000 -->
<!-- 00110001 00110000 00110000 00110000 00110001 00110001 00110001 00110001 00100000 -->
`

export default function EasterEgg() {
    // How to render HTML comments using React https://stackoverflow.com/a/77161592
    const callback = (instance: HTMLScriptElement | null) => {
        if (instance) {
            instance.outerHTML = comments;
        }
    };
    return (
        <script ref={callback} type="text/comment" dangerouslySetInnerHTML={{__html: comments}}/>
    );

};
