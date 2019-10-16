function rgbToHex(r, g, b) {
    r = Math.floor(r).toString(16);
    g = Math.floor(g).toString(16);
    b = Math.floor(b).toString(16);

    r = r.length === 1 ? "0" + r : r;
    g = g.length === 1 ? "0" + g : g;
    b = b.length === 1 ? "0" + b : b;

    return "#" + r + g + b;
}

function hslToRgb(h, s, l) {
  let r, g, b;

  if (s === 0) {
    r = g = b = l;
  } else {
    const hue2rgb = (p, q, t) => {
      if (t < 0) t += 1;
      if (t > 1) t -= 1;
      if (t < 1/6) return p + (q - p) * 6 * t;
      if (t < 1/2) return q;
      if (t < 2/3) return p + (q - p) * (2/3 - t) * 6;
      return p;
    }

    const q = l < 0.5 ? l * (1 + s) : l + s - l * s;
    const p = 2 * l - q;

    r = hue2rgb(p, q, h + 1/3);
    g = hue2rgb(p, q, h);
    b = hue2rgb(p, q, h - 1/3);
  }
  return rgbToHex(r * 255, g * 255, b * 255);
}

function redToHex(red) {
    return '#' + Math.floor(red).toString(16) + "0000";
}

function greenToHex(green) {
    return "#00" + Math.floor(green).toString(16) + "00";
}

function blueToHex(blue) {
    return "#0000" + Math.floor(blue).toString(16);
}

let effects = [];

function addEffect(effect) {
    effect = effect.split('*')[1];                  // Remove * from string
    if (duplicateInArray(effect, effects)) return;
    effects.push(effect);
}

function duplicateInArray(item, arr) {
    for (let i in arr) {
        if (arr[i] === item) return true;
    }
    return false;
}

function millisToTime(millis) {
    const seconds = Math.floor((millis / 1000) % 60);
    const minutes = Math.floor(((millis / 1000 / 60) % 60));
    const hours = Math.floor((millis / 1000 / 60 / 60));
    if (!minutes) return seconds + " seconds";
    if (!hours) return minutes + "min " + seconds + "s";
    return hours + "h " + minutes + "min";
}

function getFormattedInterval(interval) {
    if (!interval)     return "Reset sleep";
    if (interval < 1)  return interval * 60 + " s";
    if (interval < 60) return interval + " min";
    return interval / 60 + " h"
}

function parseMessage(msg) {
    let str = msg.substring(1).split(',');
    return { sleep: str[0], speed: str[1], effect: str[2], hue: str[3], brightness: str[4] };
}

function reScale(x, inMin, inMax, outMin, outMax) {
    return (x - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
}

