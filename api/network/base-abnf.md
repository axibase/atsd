# Base ABNF Rules

## Text Rules

```elm
  ; printable characters
  ; value must be enclosed in double quotes if it contains double-quote (") or equal (=) character
  ; inner double-quote must be escaped with another double quote
  ; t:"tag=name"=tag-value
  ; t:"tag""=name"=tag-value
NAME = NAME_QUOTED / 1*CHAR_SAFE

  ; printable and non-printable characters such as space, tab, line feed, carriage return
  ; value must be enclosed in double quotes if it contains double-quote ("), equal (=), or a non-printable character
  ; inner double-quote must be escaped with another double quote
  ; m:"my=message"
  ; m:"my message"
  ; m:"my 
  ;       message"
VALUE = VALUE_QUOTED / 1*CHAR_SAFE

NAME_QUOTED = DQUOTE 1*(CHAR_SAFE / EQUAL / DQUOTE DQUOTE) DQUOTE

VALUE_QUOTED = DQUOTE 1*(CHAR_SAFE / EQUAL / DQUOTE DQUOTE / SPACE / CR / LF / TB) DQUOTE

BOOLEAN = "true" / "false" / DQUOTE ("true" / "false") DQUOTE

MSP = 1*SP    ; multiple spaces
SPACE = %x20  ; space
DQUOTE = %x22 ; double-quote
EQUAL = %x3D  ; equal sign
CR = %x0D     ; carriage return
LF = %x0A     ; line feed
TB = %x09     ; tab

  ; printable character except double-quote (") and equal (=) characters
CHAR_SAFE = %x21 / %x23-3C / %x3E-7E / UNICODE
  ; Unicode character
  ; https://tools.ietf.org/html/rfc6531#section-3.3
UNICODE = %x80-FF / ; Latin-1 Supplement
          %x100-17F / ; Latin Extended-A
          %x370-3FF / ; Greek and Coptic
          %x400-4FF / ; Cyrillic
          %x500-52F / ; Cyrillic Supplement
          %x4E00-9FFF ; CJK Unified Ideographs
```

## Date Rules

```elm
  ; ISO date defined in RFC-3339 Appendix-A. 
  ; Format yyyy-MM-dd'T'HH:mm:ss.SSSXX
  ; https://tools.ietf.org/html/rfc3339#appendix-A
  ; UTC time zone (Z) = 2016-06-01T16:00:15.142Z
  ; Numeric time zone = 2016-06-01T12:00:15.142-04:00
ISO_DATE = date-time 
  ; inhereted from /shared/timezone-abnf.md
TIMEZONE = time-zone-code
```

## Number Rules

```elm
NUMBER = ["-"] (FRACTIONAL_NUMBER / REAL_NUMBER) / "NaN"
FRACTIONAL_NUMBER = ("0" / POSITIVE_INTEGER) ["." 1*DIGIT]
POSITIVE_INTEGER = %x31-39 *DIGIT
  ; "0" to "9"
DIGIT = %x30-39
  ; https://tools.ietf.org/html/rfc3642  4.  ASN.1 Built-in Types
REAL_NUMBER = MANTISSA EXPONENT
MANTISSA   = (POSITIVE_INTEGER [ "." *DIGIT ]) / ( "0." *"0" POSITIVE_INTEGER)
EXPONENT   = ["E"/"e"] ( "0" / ([ "-" ] POSITIVE_INTEGER))
```
