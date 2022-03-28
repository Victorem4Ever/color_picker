import clipboard
import ui
import gx

#flag -lGdi32

#include "windows.h"
#include "wingdi.h"

[typedef]
type COLORREF = int

struct Point {

	x int
	y int

}

struct App {
mut:
	window &ui.Window = 0

}



fn C.GetDC(int) C.HDC
fn C.GetPixel(C.HDC, int, int) COLORREF
fn C.GetAsyncKeyState(int) u16
fn C.GetCursorPos(point &Point) bool

fn main() {
	
	for {

		if (C.GetAsyncKeyState(C.VK_ESCAPE) & 1) == 1 && (C.GetAsyncKeyState(C.VK_RETURN) & 1) == 1 {

			choice()

		}

	}

}

fn get_color(mode string) {

	p := Point{

		x: 0
		y: 0

	}

	cursor := C.GetCursorPos(&p)
	if cursor {

		mut cb := clipboard.new()
		dc := C.GetDC(C.NULL)

		x := p.x
		y := p.y

		color := C.GetPixel(dc, x, y)
		r := color & 0xFF
		g := (color & 0xFF00) >> 8 
		b := color >> 16

		if mode == "RGB" {
		
			cb.copy("($r, $g, $b)")
		
		} else {

			cb.copy("#" + r.hex().str() + g.hex().str() + b.hex().str())

		}

	}

}

fn choice() {

	mut app := &App{}

	window := ui.window(
		width: 200
		height: 200
		title: 'Color Picker'
		resizable: false
		bg_color: gx.rgb(69,69,69)
		state: app
		children: [
			ui.column(
				margin: ui.Margin{
					right: .1
					left: .1
					top: .2
				}
				heights: [.2, .2]
				alignments: ui.HorizontalAlignments{
					center: [0, 0]
				}
				children: [
					ui.button(
						text: 'RGB'
						onclick: fn (app &App, b &voidptr) {
							go on_click("RGB")
						}
					),
					ui.button(
						text: "Hexa"
						onclick: fn (app &App, b &voidptr) {
							go on_click("hexa")
						}
					),
				]
			),
		]
	)
	app.window = window
	ui.run(window)	

}

fn on_click(mode string) {

	for {

		if (C.GetAsyncKeyState(C.VK_RETURN) & 1) == 1 {

			get_color(mode)

		}

	}

}