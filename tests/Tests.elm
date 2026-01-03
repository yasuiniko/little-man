module Tests exposing (..)

import Expect
import Test exposing (..)
import Dict
import Domain.Store.Utils exposing (getItemPps) -- Replace with your module name
import Domain.Store.Model exposing (ItemId(..))
import Domain.Store.Model exposing (itemMeta)
import Domain.Store.Utils exposing (getCursorFactoryBonus)
import Domain.Store.Utils exposing (getNeighborBoost)

suite : Test
suite =
    describe "getItemPps Logic"
        [ test "Grandma self-boost" <|
            \_ ->
                let
                    -- Mock data
                    item = { id = Grandma, qty = 5, basePps = 1.0, curPps = 1.0, description = "Grandma", baseCost = 15 }
                    owned = Dict.fromList [ ("Grandma", 5) ]
                    
                    -- We expect (1.0 + 0.0) * (1.02^5) * (1.005^5) * 1.0
                    expected = (1.0 + 0.0) * (1.02^4) * (1.005^5) * 1.0
                    result = getItemPps item owned
                in
                result |> Expect.within (Expect.Absolute 0.0001) expected

        , test "Cursor gets flat boost from Factories: getCursorFactoryBonus" <|
            \_ ->
                let
                    item = { id = Cursor, qty = 1, basePps = 0.1, curPps = 0.1, baseCost = 10, description = "Cursor"}
                    -- Setting up 25 other items to trigger the 0.1 flat boost
                    owned = Dict.fromList [ ("Cursor", 1), ("Factory", 1), ("Grandma", 25) ]

                    expected =  0.1
                    result = getCursorFactoryBonus (itemMeta item.id).name owned
                in
                result |> Expect.within (Expect.Absolute 0.0001) expected

        , test "Neighbor bonus" <|
            \_ ->
                let
                    item = { id = Grandma, qty = 1, basePps = 0.1, curPps = 0.1, baseCost = 10, description = "Grandma"}
                    owned = Dict.fromList [ ("Farm", 25), ("Grandma", 1) ]

                    expected = 1.3^3
                    result = getNeighborBoost (itemMeta item.id).name owned
                in
                result |> Expect.within (Expect.Absolute 0.0001) expected

               , test "Cursor gets flat boost from Factories: getItemPps" <|
            \_ ->
                let
                    item = { id = Cursor, qty = 1, basePps = 0.1, curPps = 0.1, baseCost = 10, description = "Cursor"}
                    -- Setting up 25 other items to trigger the 0.1 flat boost
                    owned = Dict.fromList [ ("Cursor", 1), ("Factory", 1), ("Grandma", 25) ]

                    expected =  (0.1 + 0.1) * (1.02^0) * (1.005^25) * 1.0
                    result = getItemPps item owned
                in
                result |> Expect.within (Expect.Absolute 0.0001) expected

        ]
