CSS Units
=========

## Length

- `in` -> `px`, `pc`, `pt`, `mm`, `cm`, `q`

  ~~~ lay
  c = (n, u) { return n.convert(u) }

  number.convert#in {
    in: c(1in,in)
    px: c(1in,px)
    cm: c(1in,cm)
    mm: c(1in,mm)
    pt: c(1in,pt)
    pc: c(1in,pc)
    q:  c(1in,q)
  }
  ~~~

  ~~~ css
  number.convert#in {
    in: 1in;
    px: 96px;
    cm: 2.54cm;
    mm: 25.4mm;
    pt: 72pt;
    pc: 6pc;
    q: 101.6q;
  }
  ~~~

- `cm` -> `in`, `px`, `pc`, `pt`, `mm`, `q`

  ~~~ lay
  c = (n, u) { return n.convert(u) }

  number.convert#cm {
    in: c(1cm,in)
    px: c(1cm,px)
    cm: c(1cm,cm)
    mm: c(1cm,mm)
    pt: c(1cm,pt)
    pc: c(1cm,pc)
    q:  c(1cm,q)
  }
  ~~~

  ~~~ css
  number.convert#cm {
    in: 0.39in;
    px: 37.8px;
    cm: 1cm;
    mm: 10mm;
    pt: 28.35pt;
    pc: 2.36pc;
    q: 40q;
  }
  ~~~

- `mm` -> `in`, `px`, `pc`, `pt`, `cm`, `q`

  ~~~ lay
  c = (n, u) { return n.convert(u) }

  number.convert#mm {
    in: c(1mm,in)
    px: c(1mm,px)
    cm: c(1mm,cm)
    mm: c(1mm,mm)
    pt: c(1mm,pt)
    pc: c(1mm,pc)
    q:  c(1mm,q)
  }
  ~~~

  ~~~ css
  number.convert#mm {
    in: 0.04in;
    px: 3.78px;
    cm: 0.1cm;
    mm: 1mm;
    pt: 2.83pt;
    pc: 0.24pc;
    q: 4q;
  }
  ~~~

- `pt` -> `in`, `px`, `pc`, `mm`, `cm`, `q`

  ~~~ lay
  c = (n, u) { return n.convert(u) }

  number.convert#pt {
    in: c(1pt,in)
    px: c(1pt,px)
    cm: c(1pt,cm)
    mm: c(1pt,mm)
    pt: c(1pt,pt)
    pc: c(1pt,pc)
    q:  c(1pt,q)
  }
  ~~~

  ~~~ css
  number.convert#pt {
    in: 0.01in;
    px: 1.33px;
    cm: 0.04cm;
    mm: 0.35mm;
    pt: 1pt;
    pc: 0.08pc;
    q: 1.41q;
  }
  ~~~

- `pc` -> `in`, `px`, `pt`, `mm`, `cm`, `q`

  ~~~ lay
  c = (n, u) { return n.convert(u) }

  number.convert#pc {
    in: c(1pc,in)
    px: c(1pc,px)
    cm: c(1pc,cm)
    mm: c(1pc,mm)
    pt: c(1pc,pt)
    pc: c(1pc,pc)
    q:  c(1pc,q)
  }
  ~~~

  ~~~ css
  number.convert#pc {
    in: 0.17in;
    px: 16px;
    cm: 0.42cm;
    mm: 4.23mm;
    pt: 12pt;
    pc: 1pc;
    q: 16.93q;
  }
  ~~~

- `q` -> `in`, `px`, `pc`, `pt`, `mm`, `cm`

  ~~~ lay
  c = (n, u) { return n.convert(u) }

  number.convert#q {
    in: c(1q,in)
    px: c(1q,px)
    cm: c(1q,cm)
    mm: c(1q,mm)
    pt: c(1q,pt)
    pc: c(1q,pc)
    q:  c(1q,q)
  }
  ~~~

  ~~~ css
  number.convert#q {
    in: 0.01in;
    px: 0.94px;
    cm: 0.03cm;
    mm: 0.25mm;
    pt: 0.71pt;
    pc: 0.06pc;
    q: 1q;
  }
  ~~~

- `px` -> `in`, `pc`, `pt`, `mm`, `cm`, `q`

  ~~~ lay
  c = (n, u) { return n.convert(u) }

  number.convert#px {
    in: c(1px,in)
    px: c(1px,px)
    cm: c(1px,cm)
    mm: c(1px,mm)
    pt: c(1px,pt)
    pc: c(1px,pc)
    q:  c(1px,q)
  }
  ~~~

  ~~~ css
  number.convert#px {
    in: 0.01in;
    px: 1px;
    cm: 0.03cm;
    mm: 0.26mm;
    pt: 0.75pt;
    pc: 0.06pc;
    q: 1.06q;
  }
  ~~~

## Time

- `ms` <-> `s`

  ~~~ lay
  number.convert#s {
    s: 1s.convert(s)
    ms: 1s.convert(ms)
    ms: -.25s.convert(ms)
  }

  number.convert#ms {
    s: 1ms.convert(s)
    s: 138ms.convert(s)
    ms: 1ms.convert(ms)
  }
  ~~~

  ~~~ css
  number.convert#s {
    s: 1s;
    ms: 1000ms;
    ms: -250ms;
  }

  number.convert#ms {
    s: 0;
    s: 0.14s;
    ms: 1ms;
  }
  ~~~

## Frequency

- `Hz`, `kHz`

  ~~~ lay
  number.convert#khz {
    khz: 1kHz.convert(kHz)
    hz: 1kHz.convert(Hz)
    hz: 0.078kHz.convert(Hz)
  }
  ~~~

  ~~~ css
  number.convert#khz {
    khz: 1kHz;
    hz: 1000Hz;
    hz: 78Hz;
  }
  ~~~

## Angle

- `deg` -> `rad`, `turn`, `grad`

  ~~~ lay
  number.convert#deg {
    deg:  1deg.convert(deg)
    rad:  1deg.convert(rad),
          180deg.convert(rad),
          720deg.convert(rad)
    turn: 1deg.convert(turn),
          180deg.convert(turn),
          720deg.convert(turn)
    grad: 1deg.convert(grad),
          180deg.convert(grad),
          720deg.convert(grad)
  }
  ~~~

  ~~~ css
  number.convert#deg {
    deg: 1deg;
    rad: 0.02rad, 3.14rad, 12.57rad;
    turn: 0, 0.5turn, 2turn;
    grad: 1.11grad, 200grad, 800grad;
  }
  ~~~

- `rad` -> `deg`, `turn`, `grad`

  ~~~ lay
  number.convert#rad {
    deg:  1rad.convert(deg),
          (PI)rad.convert(deg),
          (4 * PI)rad.convert(deg)
    rad:  1rad.convert(rad)
    turn: 1rad.convert(turn),
          (PI)rad.convert(turn),
          (4 * PI)rad.convert(turn)
    grad: 1rad.convert(grad),
          (PI)rad.convert(grad),
          (4 * PI)rad.convert(grad)
  }
  ~~~

  ~~~ css
  number.convert#rad {
    deg: 57.3deg, 180deg, 720deg;
    rad: 1rad;
    turn: 0.16turn, 0.5turn, 2turn;
    grad: 63.66grad, 200grad, 800grad;
  }
  ~~~

- `turn` -> `deg`, `rad`, `grad`

  ~~~ lay
  number.convert#turn {
    deg:  1turn.convert(deg),
          .25turn.convert(deg),
          2turn.convert(deg)
    rad:  1turn.convert(rad),
          .25turn.convert(rad),
          2turn.convert(rad)
    turn: 1turn.convert(turn)
    grad: 1turn.convert(grad),
          .25turn.convert(grad),
          2turn.convert(grad)
  }
  ~~~

  ~~~ css
  number.convert#turn {
    deg: 360deg, 90deg, 720deg;
    rad: 6.28rad, 1.57rad, 12.57rad;
    turn: 1turn;
    grad: 400grad, 100grad, 800grad;
  }
  ~~~

- `grad` -> `deg`, `rad`, `turn`

  ~~~ lay
  number.convert#grad {
    deg:  1grad.convert(deg),
          50grad.convert(deg),
          600grad.convert(deg)
    rad:  1grad.convert(rad),
          50grad.convert(rad),
          600grad.convert(rad)
    turn: 1grad.convert(turn),
          100grad.convert(turn),
          600grad.convert(turn)
    grad: 1grad.convert(grad)
  }
  ~~~

  ~~~ css
  number.convert#grad {
    deg: 0.9deg, 45deg, 540deg;
    rad: 0.02rad, 0.79rad, 9.42rad;
    turn: 0, 0.25turn, 1.5turn;
    grad: 1grad;
  }
  ~~~

## Resolution

- `dpi` <-> `dppx` <-> `dpcm`

  ~~~ lay
  number.convert#dpi {
    dpi: 1dpi.convert(dpi)
    dppx: 1dpi.convert(dppx)
    dpcm: 1dpi.convert(dpcm)
  }

  number.convert#dppx {
    dpi:  1dppx.convert(dpi)
    dppx: 1dppx.convert(dppx)
    dpcm: 1dppx.convert(dpcm)
  }

  number.convert#dpcm {
    dpi:  1dpcm.convert(dpi)
    dppx: 1dpcm.convert(dppx)
    dpcm: 1dpcm.convert(dpcm)
  }
  ~~~

  ~~~ css
  number.convert#dpi {
    dpi: 1dpi;
    dppx: 0.01dppx;
    dpcm: 0.39dpcm;
  }

  number.convert#dppx {
    dpi: 96dpi;
    dppx: 1dppx;
    dpcm: 37.8dpcm;
  }

  number.convert#dpcm {
    dpi: 2.54dpi;
    dppx: 0.03dppx;
    dpcm: 1dpcm;
  }
  ~~~
