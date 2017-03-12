module Navbar exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Css
import Bootstrap.Button as Button
import Bootstrap.Form.Input as Input
import Bootstrap.Navbar as Navbar exposing (State)
import MainCss
import RouteHelper exposing (..)


view : State -> Route -> (String -> msg) -> (State -> msg) -> Html msg
view state currentRoute changeLocationMsgTagger navbarMsgTagger =
    div []
        [ Navbar.config navbarMsgTagger
            |> Navbar.withAnimation
            |> Navbar.collapseMedium
            |> Navbar.fixTop
            |> Navbar.brand
                [ href "/" ]
                [ img
                    [ src "static/img/elm-bootstrap.svg"
                      -- , class "d-inline-block align-top"
                    , style [ ( "width", "30px" ) ]
                    ]
                    []
                , text " Project"
                ]
            |> Navbar.items
                [ routeToItemLink changeLocationMsgTagger currentRoute HomeRoute " Home"
                , routeToItemLink changeLocationMsgTagger currentRoute AboutRoute " About"
                , Navbar.dropdown
                    { id = "mydropdown"
                    , toggle = Navbar.dropdownToggle [] [ text "My dropdown" ]
                    , items =
                        [ Navbar.dropdownHeader [ text "Heading" ]
                        , routeToDropdownItem changeLocationMsgTagger HomeRoute "Drop Item 1"
                        , routeToDropdownItem changeLocationMsgTagger HomeRoute "Drop Item 2"
                        , Navbar.dropdownDivider
                        , routeToDropdownItem changeLocationMsgTagger HomeRoute "Drop Item 3"
                        ]
                    }
                ]
            |> Navbar.customItems
                [ Navbar.formItem []
                    [ Input.text [ Input.attrs <| [ placeholder "enter" ] ]
                    , Button.button
                        [ Button.success
                        , Button.attrs [ Html.Attributes.class "ml-sm-2" ]
                        ]
                        [ text "Search" ]
                    ]
                , Navbar.textItem [ Html.Attributes.class "muted ml-sm-2" ] [ text "Text" ]
                ]
            |> Navbar.view state
        ]


routeToItemLink : (String -> msg) -> Route -> Route -> String -> Navbar.Item msg
routeToItemLink changeLocationMsgTagger currentRoute linkedToRoute title =
    let
        path =
            encode linkedToRoute

        itemLink =
            if currentRoute == linkedToRoute then
                Navbar.itemLinkActive
            else
                Navbar.itemLink
    in
        itemLink
            [ href path
            , MainCss.styles [ Css.float Css.right ]
            , attribute "data-navigate" path
            , catchNavigationClicks (changeLocationMsgTagger path)
            ]
            [ text title ]


routeToDropdownItem : (String -> msg) -> Route -> String -> Navbar.DropdownItem msg
routeToDropdownItem changeLocationMsgTagger linkedToRoute title =
    let
        path =
            encode linkedToRoute
    in
        Navbar.dropdownItem
            [ href path
            , attribute "data-navigate" path
            , catchNavigationClicks (changeLocationMsgTagger path)
            ]
            [ text title ]
