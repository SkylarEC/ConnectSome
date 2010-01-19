/***************************************************************************
**                                                                        **
**                          Connect-4 Algorithm                           **
**                                                                        **
**                              Version 3.11                              **
**                                                                        **
**                            By Keith Pomakis                            **
**                          (pomakis@pobox.com)                           **
**                                                                        **
**                             November, 2009                             **
**                                                                        **
****************************************************************************
**                                                                        **
**                  See the file "c4.c" for documentation.                **
**                                                                        **
****************************************************************************
**  $Id: c4.h,v 3.11 2009/11/03 14:42:07 pomakis Exp pomakis $
***************************************************************************/

/*
		11/21/09	--Added function to return game_in_progress
					--Skylar Cantu											*/

#ifndef C4_DEFINED
#define C4_DEFINED

#include <time.h>
#include <stdbool.h>

#define C4_NONE      2
#define C4_MAX_LEVEL 20

/* See the file "c4.c" for documentation on the following functions. */

extern void    c4_poll(void (*poll_func)(void), clock_t interval);
extern void    c4_new_game(int width, int height, int num);
extern bool    c4_make_move(int player, int column, int *row);
extern bool    c4_auto_move(int player, int level, int *column, int *row);
extern char ** c4_board(void);
extern int     c4_score_of_player(int player);
extern bool    c4_is_winner(int player);
extern bool    c4_is_tie(void);
extern void    c4_win_coords(int *x1, int *y1, int *x2, int *y2);
extern void    c4_end_game(void);
extern void    c4_reset(void);

extern const char *c4_get_version(void);

/*	New data retrieval methods added by Skylar Cantu for the ConnectSome iPhone adaptation of this code	*/

extern bool    c4_game_in_progress(void);

#endif /* C4_DEFINED */
